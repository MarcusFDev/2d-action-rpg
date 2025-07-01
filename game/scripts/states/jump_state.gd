class_name JumpState
extends State

## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_internal_logic: bool = true
## Determines the animation that plays during the Jump State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var jump_animation: String
## Determines the seconds the state takes to reach the  [code]jump_height[/code]  value.[br]
## [b]Note:[/b] Can exceed 3 seconds with manual input.[br]
## [b]Warning:[/b] If time value exceeds  [code]jump_height[/code]  value unexpected behavior may occur.
@export_range(0.0, 3.0, 0.1, "or_greater", "suffix:s") var jump_time: float = 1.0
## Determines the height the entity attempts to reach. [br]
## [b]Note:[/b] Can exceed 100 pixels with manual input.[br]
## [b]Warning:[/b] If time value falls below  [code]jump_time[/code]  value unexpected behavior may occur.
@export_range(0.0, 100.0, 0.5, "or_greater", "suffix:px") var jump_height: float = 30.0
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_group("Internal Logic Settings")

## Assign State node to transition to when  [code]next_state[/code]  is called. [br]
## [b]Note:[/b] Idle state will transition automatically to this node.
@export var next_state: State = null
## Assign State node to transition to when  [code]fall_state[/code]  is called. [br]
@export var fall_state: State = null

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

func enter() -> void:
	super.enter()
	init_jump()

func init_jump() -> void:
	parent.animations.play(jump_animation)

	var calculated_gravity: float = (2.0 * jump_height) / pow(jump_time, 2)
	var initial_velocity: float = -calculated_gravity * jump_time
	
	parent.velocity.y = initial_velocity
	gravity = calculated_gravity
	
	if enable_debug:
		print("Jump initialized:")
		print("  Jump Height: ", jump_height)
		print("  Jump Speed: ", jump_time)
		print("  Initial velocity: ", initial_velocity)
		print("  Calculated Gravity: ", calculated_gravity)

	if use_internal_logic:
		pass
	else:
		enter_callback.call()

func process_physics(delta: float) -> State:
	if use_internal_logic:
		parent.velocity.y += gravity * delta
		parent.move_and_slide()
		
		if parent.velocity.y > 0:
			return fall_state
		return null
	else:
		return handle_physics.call(delta)

func process_input(event: InputEvent) -> State:
	if not use_internal_logic:
		return handle_input.call(event)
	return null

func process_frame(delta: float) -> State:
	if not use_internal_logic:
		return handle_frame.call(delta)
	return null

func exit() -> void:
	pass
