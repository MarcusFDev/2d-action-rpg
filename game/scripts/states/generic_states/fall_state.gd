class_name FallState
extends State

@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("State Settings")
## Determines the animation that plays during the Fall State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var state_animation: String
@export var use_behavior_tree: bool = false
@export var use_parent_logic: bool = false

@export_group("Component Paths")
@export var gravity_component: NodePath

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)
@onready var gravity_comp: Node = get_node_or_null(gravity_component)

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
	if enable_debug:
		print(
		"===========================\n",
		"FallState entered by: ", actor.name, "\n",
		"===========================")
	
	init_fall()

func init_fall() -> void:
	animations.play(state_animation)
	enter_callback.call()
	
	if use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		bb["locked"] = true

func process_physics(_delta: float) -> State:
	gravity_comp.apply(_delta)
	if use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		if actor.is_on_floor():
			bb["can_patrol"] = true
			bb["is_grounded"] = true
			bb["locked"] = false
		else:
			bb["is_grounded"] = false

	if use_parent_logic:
		return handle_physics.call(_delta)

	return null

func exit() -> void:
	if enable_debug:
		print(actor.name, " Exiting FallState.")
