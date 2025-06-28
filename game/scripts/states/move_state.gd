class_name MoveState
extends State

## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_internal_logic: bool = true
## Determines the animation that plays during the Move State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var move_animation: String
## Determines entity movement speed during the Move State. [br]
## [b]Note:[/b] Can exceed 200 with manual input.
@export_range(0, 200, 1, "suffix:px/s", "or_greater") var move_speed: float = 30.0
## Determines whether the entity's animation flips horizontally while moving using  [code]flip_h[/code].[br]
## [b]Note:[/b] Useful to set  [code]false[/code]  for symmetric & direction-agnostic entities.
@export var use_direction_flip: bool = false
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_group("Internal Logic Settings")
## Assign State node to transition to when  [code]fall_state[/code]  is called.
@export var fall_state: State
## Assign State node to transition to when  [code]idle_state[/code]  is called.
@export var idle_state: State
## Determines whether entity uses idle timer to randomly go idle during Move State. [br]
## [b]Note:[/b] If set to  [code]false[/code]  entity will not randomly idle.
@export var use_idle_timer: bool = false
## Determines frequency of random idle attempts.[br]
## [b]Note:[/b] Can exceed 3 seconds with manual input.[br] 
## [b]Requires idle timer set to  [code]true[/code]  to take effect.[/b]
@export_range(0, 3, 0.1, "suffix:s", "or_greater") var idle_check_interval: float = 1.0
## Determines a % chance of entity randomly entering idle.[br]
## [b]Note:[/b] Cannot go below the value of a 1%.[br]
## [b]Requires idle timer set to  [code]true[/code]  to take effect.[/b]
@export_range(1, 100, 1, "suffix:%") var idle_chance_percent: float = 20

# Raycast-based wall detection
## Assigns the  [code]RayCast2D[/code]  node used to detect collisions on the [b]right side[/b] of the entity.[br]
@export var raycast_right_path: NodePath
## Assigns the  [code]RayCast2D[/code]  node used to detect collisions on the [b]left side[/b] of the entity.[br]
@export var raycast_left_path: NodePath

# Script Variables
var ray_right: RayCast2D
var ray_left: RayCast2D
var delay_timer: float = 0.15
var idle_chance_timer: float = 0.0
var direction: int = 1

# Callbacks
var enter_callback: Callable = func(): return
var handle_frame: Callable = func(_delta): return null
var handle_input: Callable = func(_event): return null
var handle_physics: Callable = func(_delta): return null

func enter():
	super.enter()
	init_move()
	
func init_move() -> void:
	parent.animations.play(move_animation)
	enter_callback.call()
	if enable_debug:
		print(
			"\n===== Move State: ===== \n", parent,
			"\nAnimation playing:", move_animation)

	if use_direction_flip:
		parent.animations.flip_h = direction < 0
		if enable_debug:
			print("Directional flip enabled. Animation flipped.", direction)
	else:
		if enable_debug:
			print("Directional flip disabled.")

	if use_internal_logic:
		if enable_debug:
			print("Internal Logic enabled.")
		delay_timer = 0.15
		idle_chance_timer = 0.0
		
		if raycast_left_path != NodePath("") and has_node(raycast_left_path):
			ray_left = get_node(raycast_left_path)

		if raycast_right_path != NodePath("") and has_node(raycast_right_path):
			ray_right = get_node(raycast_right_path)
		
		if enable_debug:
			print(
				"RayCast2D Left Node:", raycast_left_path,
				"\nRayCast2D Right Node:", raycast_right_path)
	else:
		if enable_debug:
			print("Internal Logic disabled.")

func get_idle_chance() -> float:
	return idle_chance_percent / 100.0

func process_physics(delta: float) -> State:
	if use_internal_logic:
		if not parent.is_on_floor():
			if enable_debug:
				print("Cannot detect floor. Switching to: ", fall_state)
			return fall_state

		parent.velocity.y += gravity * delta
		parent.velocity.x = direction * move_speed
		parent.move_and_slide()
		return null
	else:
		return handle_physics.call(delta)

func process_frame(delta: float) -> State:
	if use_internal_logic:
		if delay_timer > 0.0:
			delay_timer -= delta
		else:
			if ray_right and ray_right.is_colliding():
				direction = -1
				parent.animations.flip_h = true
				idle_state.set_direction(direction)
				if enable_debug:
					print("RayRight collided. Switching to: ", idle_state)
				return idle_state
			elif ray_left and ray_left.is_colliding():
				direction = 1
				parent.animations.flip_h = false
				idle_state.set_direction(direction)
				if enable_debug:
					print("RayLeft collided. Switching to: ", idle_state)
				return idle_state

		if use_idle_timer:
			idle_chance_timer += delta
			if idle_chance_timer >= idle_check_interval:
				idle_chance_timer = 0.0
				if randf() < get_idle_chance():
					idle_state.set_direction(direction)
					if enable_debug:
						print("Idle Timer triggered. Switching to: ", idle_state)
					return idle_state

		parent.animations.flip_h = direction < 0
		return null
	else:
		return handle_frame.call(delta)
