class_name FallState
extends State

## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_internal_logic: bool = true
## Determines the animation that plays during the Fall State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var fall_animation : String
## Determines whether the entity's animation flips horizontally while moving using  [code]flip_h[/code].[br]
## [b]Note:[/b] Useful to set  [code]false[/code]  for symmetric & direction-agnostic entities.
@export var use_direction_flip: bool = true
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_group("Internal Logic Settings")

## Assign State node to transition to when  [code]next_state[/code]  is called. [br]
## [b]Note:[/b] Idle state will transition automatically to this node.
@export var next_state: State = null

var direction: int = 1

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
	init_fall()

func init_fall() -> void:
	animations.play(fall_animation)
	pass

func process_physics(_delta: float) -> State:
	if use_direction_flip:
		if parent.velocity.x != 0:
			direction = sign(parent.velocity.x)
			parent.animations.flip_h = direction < 0
			if enable_debug:
				print("Directional flip enabled. Animation flipped.", direction)
		else:
			if enable_debug:
				print("Directional flip disabled.")

	if use_internal_logic:
		parent.velocity.y += gravity * _delta
		parent.move_and_slide()
		if parent.is_on_floor():
			return next_state
	else:
		return handle_physics.call(_delta)
	return null

func exit() -> void:
	pass
