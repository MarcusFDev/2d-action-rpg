class_name DeathState
extends State

## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_internal_logic: bool = true
## Determines the animation that plays during the Death State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var death_animation : String
## Determines the post-death  [code]method[/code]  the parent class uses to handle what happens when animation finishes.[br]
## [b]Note:[/b] Must match method name exactly or unintended behavior may occur.
@export var post_death_method: String
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

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
	init_death()

func init_death() -> void:
	parent.animations.play(death_animation)
	
	if use_internal_logic:
		parent.velocity = Vector2.ZERO
		if not animations.animation_finished.is_connected(animation_finished):
			animations.animation_finished.connect(animation_finished, CONNECT_ONE_SHOT)

	if enable_debug:
		print(
			"\n===== Death State: ===== \n", parent,
			"\nAnimation playing: ", death_animation,
			"\nVelocity set to: ", parent.velocity)
	else:
		enter_callback.call()

func process_physics(_delta: float) -> State:
	return null

func animation_finished() -> void:
	if animations.animation == death_animation:
		if enable_debug:
			print("Death Animation finished.")

		if post_death_method != "" and parent.has_method(post_death_method):
			if enable_debug:
				print("Post Death method set to: ", post_death_method)
			parent.call(post_death_method)
		else:
			if enable_debug:
				print(post_death_method, " method either does not exist in parent.")

func exit() -> void:
	pass
