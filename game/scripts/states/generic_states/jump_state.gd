class_name JumpState
extends State

## Determines the animation that plays during the Jump State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var jump_animation: String

@export var use_behavior_tree: bool = false
@export var use_parent_logic: bool = false
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@onready var gravity_component: Node = $"../../Components/GravityComponent"
@onready var jump_component: Node = $"../../Components/JumpComponent"

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

var direction: int = 0

func enter() -> void:
	super.enter()
	init_jump()

func init_jump() -> void:
	parent.animations.play(jump_animation)
	if use_parent_logic:
		jump_component.start_jump()
	if enable_debug:
		print(
		"===========================\n",
		"jumpstate entered by: ", parent.name, "\n",
		"===========================")

func process_physics(delta: float) -> State:
	if use_behavior_tree:
		var bb: Dictionary = parent.get_blackboard()
		direction = bb["move_direction"]
		var jump_target: Variant = parent.global_position + Vector2(64 * direction, -32)
		jump_component.jump_to(jump_target)
	
	parent.move_and_slide()
	
	if use_parent_logic:
		jump_component.apply(delta)
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
	pass
