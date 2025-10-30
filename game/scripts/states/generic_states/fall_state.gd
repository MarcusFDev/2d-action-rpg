class_name FallState
extends State

## Determines the animation that plays during the Fall State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var fall_animation : String
@export var use_behavior_tree: bool = false
## Determines whether this state uses parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all parent logic settings are ignored.
@export var use_parent_logic: bool = false
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@onready var gravity_component: Node = $"../../Components/GravityComponent"

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
	enter_callback.call()
	
	if enable_debug:
		print(
			"\n===== Fall State: ===== \n", parent,
			"\nAnimation playing:", fall_animation)

func process_physics(_delta: float) -> State:
	gravity_component.apply(_delta)
	if use_behavior_tree:
		var bb: Dictionary = parent.get_blackboard()
		if parent.is_on_floor():
			bb["can_patrol"] = true
			bb["is_grounded"] = true
		else:
			bb["can_patrol"] = false
			bb["is_grounded"] = false

	if use_parent_logic:
		return handle_physics.call(_delta)

	return null

func exit() -> void:
	if enable_debug:
		print("Exiting FallState.")
