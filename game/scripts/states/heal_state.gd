class_name HealState
extends State

## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_internal_logic: bool = true
## Determines the animation that plays during the Heal State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var heal_animation : String
## Assign State node to transition to when  [code]next_state[/code]  is called. [br]
## [b]Note:[/b] Heal state will transition automatically to this node.
@export var next_state: State = null
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

# Script Variables
var is_finished : bool = false

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
	init_heal()

func init_heal() -> void:
	parent.animations.play(heal_animation)
	if use_internal_logic:
		parent.velocity.x = 0
		if not animations.animation_finished.is_connected(animation_finished):
			animations.animation_finished.connect(animation_finished, CONNECT_ONE_SHOT)

	if enable_debug:
		print(
			"\n===== Heal State: ===== \n", parent,
			"\nAnimation playing: ", heal_animation,
			"\nVelocity set to: ", parent.velocity)
	else:
		enter_callback.call()

func process_physics(delta: float) -> State:
	if use_internal_logic:
		parent.velocity.y += gravity * delta
		if parent.is_on_floor():
			parent.velocity.y = 0
		parent.move_and_slide()
	else:
		return handle_physics.call(delta)
	return null

func process_frame(_delta: float) -> State:
	if is_finished:
		return next_state
	return null

func animation_finished() -> void:
	if animations.animation == heal_animation:
		if enable_debug:
			print("Heal Animation finished.")
		if use_internal_logic:
			is_finished = true

func exit() -> void:
	is_finished = false
	pass
