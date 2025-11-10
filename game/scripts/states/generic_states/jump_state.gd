class_name JumpState
extends State

@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("State Settings")
## Determines the animation that plays during the Jump State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var state_animation: String
@export var use_parent_logic: bool = false

@export_group("Use Behavior Tree", "export_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_use_behavior_tree: bool = false

@export_subgroup("Enable Randomize Direction", "export_")
## Determines if entity can randomly change direction during movement. [br]
## [b]Note:[/b] Only impacts BehaviorTree driven entities. [br]
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_randomize_direction: bool = false
## Determines how often the state checks whether the entity should randomly change direction. [br]
## [b]Tip:[/b] Larger values make random direction swaps less frequent. [br]
## [b]Note:[/b] Setting to [code]0[/code] disables random direction swaps entirely.
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var export_swap_interval: float = 0
## Determines the percentage chance (0–100%) that the entity will decide to swap direction each time a random check occurs. [br]
## [b]Note:[/b] Low values make random direction changing rare and natural; higher values increase frequency. [br]
@export_range(0, 100, 1, "suffix:%") var export_swap_chance: float = 0

@export_subgroup("Enable Random Idle", "export_")
## Determines if entity can randomly idle during movement. [br]
## [b]Note:[/b] Only impacts BehaviorTree driven entities. [br]
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_random_idle: bool = false
## Determines how often the component checks whether the entity should randomly enter an idle state. [br]
## [b]Tip:[/b] Larger values make random idle checks less frequent. [br]
## [b]Note:[/b] Setting to [code]0[/code] disables random idle checks entirely.
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var export_idle_interval: float = 0
## Determines the percentage chance (0–100%) that the entity will decide to idle each time a random check occurs. [br]
## [b]Note:[/b] Low values make random idling rare and natural; higher values increase frequency. [br]
@export_range(0, 100, 1, "suffix:%") var export_idle_chance: float = 0

@export_subgroup("Enable Random Patrol", "export_")
## Determines if entity can randomly patrol during movement. [br]
## [b]Note:[/b] Only impacts BehaviorTree driven entities. [br]
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_random_patrol: bool = false
## Determines how often the component checks whether the entity should randomly enter an patrol state. [br]
## [b]Tip:[/b] Larger values make random patrol checks less frequent. [br]
## [b]Note:[/b] Setting to [code]0[/code] disables random patrol checks entirely.
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var export_patrol_interval: float = 0
## Determines the percentage chance (0–100%) that the entity will decide to patrol each time a random check occurs. [br]
## [b]Note:[/b] Low values make random patrolling rare and natural; higher values increase frequency. [br]
@export_range(0, 100, 1, "suffix:%") var export_patrol_chance: float = 0

@export_group("Component Paths")

@export var gravity_component: NodePath
@export var ground_check_component: NodePath
@export var jump_component: NodePath
@export var movement_component: NodePath
@export var randomizer_component: NodePath

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)
@onready var ground_check_comp: Node = get_node_or_null(ground_check_component)
@onready var jump_comp: Node = get_node_or_null(jump_component)
@onready var gravity_comp: Node = get_node_or_null(gravity_component)
@onready var movement_comp: Node = get_node_or_null(movement_component)
@onready var randomizer_comp: Node = get_node_or_null(randomizer_component)

# Callback Functions
func _on_enter() -> void: pass
func _on_input(_event: InputEvent) -> void: pass
func _on_physics(_delta: float) -> void: pass
func _on_frame(_delta: float) -> void: pass

# Callback Variables
var enter_callback: Callable = _on_enter
var handle_input: Callable = _on_input
var handle_physics: Callable = _on_physics
var handle_frame: Callable = _on_frame

# Script Variables
var direction: int = 0
var state_direction: Variant
var jumps_remaining: int = 0
var jump_timer: float = 0.0
var jump_cooldown: bool = false

# --------------------------------------------------------------------
# STATE ENTER
# --------------------------------------------------------------------
func enter() -> void:
	super.enter()
	if enable_debug:
		print(
		"===========================\n",
		"JumpState entered by: ", actor.name, "\n",
		"===========================")
	init_jump()

func init_jump() -> void:
	actor.animations.play(state_animation)
	
	if use_parent_logic:
		jump_comp.perform_jump()
	
	if export_use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		bb["locked"] = true
		bb["force_jump"] = false
		bb["can_jump"] = false
		direction = bb["move_direction"]
		
		jumps_remaining = jump_comp.base_jumps + jump_comp.initial_extra_jumps

		if enable_debug:
			print(
				actor.name,
				" | JumpState: Combining Base Jumps: ", jump_comp.base_jumps,
				" & Extra Jumps: ", jump_comp.initial_extra_jumps,
				" to: ", jumps_remaining, " jumps.")

# --------------------------------------------------------------------
# STATE PHYSICS
# --------------------------------------------------------------------
func process_physics(delta: float) -> State:
	actor.move_and_slide()
	jump_comp.apply_physics(delta)

	if export_use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		var grounded: bool = bb["is_grounded"]
		var collided: bool = bb["has_collided"]
		
		if grounded:
			if not jump_comp.cooldown_active and jumps_remaining > 0:
				
				if export_enable_randomize_direction and not collided:
					var result : Dictionary = movement_comp. direction_randomizer("jump", export_swap_chance, export_swap_interval, delta)
					if result.success:
						state_direction = result.direction
					else:
						state_direction = bb["move_direction"]
				else:
					state_direction = bb["move_direction"]
				
				jump_comp.perform_target_jump(state_direction)
				jump_comp.start_cooldown()
				
				jumps_remaining -= 1
				
			elif jump_comp.cooldown_active:
				actor.velocity.x = 0
				pass
			
			else:
				jump_comp.reset_jump_counter()
				bb["can_jump"] = true
				bb["locked"] = false
				bb["can_patrol"] = true
				bb["has_collided"] = false

				if enable_debug:
					print(actor.name, " | JumpState finished all jumps.")
		
		if export_enable_random_idle and grounded:
			var can_idle : bool = randomizer_comp.randomizer("idle", export_idle_chance, export_idle_interval, delta)
			if can_idle:
				if enable_debug:
					print(actor.name, "JumpState: Random Idle enabled & can idle.")
				bb["force_idle"] = true
				bb["has_collided"] = false
				bb["can_jump"] = false
				bb["locked"] = false
	
		if export_enable_random_patrol and grounded:
			var can_patrol : bool = randomizer_comp.randomizer("patrol", export_patrol_chance, export_patrol_interval, delta)
			if can_patrol:
				if enable_debug:
					print(actor.name, "JumpState: Random Patrol enabled & can patrol.")
				bb["force_patrol"] = true
				bb["has_collided"] = false
				bb["can_patrol"] = true
				bb["can_jump"] = false
				bb["locked"] = false

	if use_parent_logic:
		return handle_physics.call(delta)
	
	return null

func process_input(event: InputEvent) -> State:
	if use_parent_logic:
		return handle_input.call(event)
	return null

func process_frame(delta: float) -> State:
	if use_parent_logic:
		return handle_frame.call(delta)
	return null

func exit() -> void:
	if enable_debug:
		print(actor.name, " | JumpState exited.")
