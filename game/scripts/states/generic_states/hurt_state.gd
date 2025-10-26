class_name HurtState
extends State

## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_internal_logic: bool = true
## Determines the animation that plays during the Hurt State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var hurt_animation : String
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_group("Internal Logic Settings")

## Assign State node to transition to when  [code]next_state[/code]  is called. [br]
## [b]Note:[/b] Hurt state will transition automatically to this node.
@export var next_state: State = null

@export_group("Components Logic")

## Enables knockback logic upon entering the state.
## [b]Note:[/b] Uses entity location to determine knockback direction.
@export var enable_knockback: bool = false
## Determines force the knockback is on the parent entity.
## [b]Note:[/b] Can exceed 200px/s by manual input.
@export_range(0, 200, 0.5, "or_greater", "suffix:px/s") var knockback_force: float = 150.0
## Enables immunity logic upon entering the state.
## [b]Note:[/b] Immunity prevents parent entity from entering state again again.
@export var enable_immunity: bool = false
## Determines seconds before parent entity can re-enter state.
## [b]Note:[/b] Can exceed 5 seconds with manual input.
@export_range(0, 5, 0.1, "or_greater", "suffix:s") var immunity_timer: float = 1.0

# Script Variables
var is_finished : bool = false
var knockback_direction: Vector2

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
	init_hurt()

func init_hurt() -> void:
	parent.animations.play(hurt_animation)
	if use_internal_logic:

		if enable_immunity:
			parent.apply_immunity(immunity_timer)
		if enable_knockback:
			parent.apply_knockback(knockback_direction, knockback_force)
		else:
			parent.velocity.x = 0
		if not animations.animation_finished.is_connected(animation_finished):
			animations.animation_finished.connect(animation_finished, CONNECT_ONE_SHOT)

	if enable_debug:
		print(
			"\n===== Hurt State: ===== \n", parent,
			"\nAnimation playing: ", hurt_animation,
			"\nVelocity set to: ", parent.velocity,
			"\nImmunity set to: ", enable_immunity,
			"\nImmunity Timer set to: ", immunity_timer,
			"\nKnockback set to: ", enable_knockback,
			"\nKnockback Force set to: ", knockback_force)
	else:
		enter_callback.call()
	pass

func set_knockback_data(direction: Vector2) -> void:
	knockback_direction = direction.normalized()
	if enable_debug:
		print("Knockback Direction: ", knockback_direction)

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
	if animations.animation == hurt_animation:
		if enable_debug:
			print("Hurt Animation finished.")
		if use_internal_logic:
			is_finished = true

func exit() -> void:
	is_finished = false
	knockback_direction = Vector2.ZERO
	pass
