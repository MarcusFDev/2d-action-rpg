class_name IdleState
extends State

@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("State Settings")
## Determines the animation that plays during the Idle State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var state_animation: String
@export var use_behavior_tree: bool = false
## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_parent_logic: bool = false

@export_group("Component Paths")
@export var idle_component: NodePath

@onready var actor: Node = get_node_or_null(actor_path)
@onready var idle_comp: Node = get_node_or_null(idle_component) 

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
		"IdleState entered by: ", actor.name, "\n",
		"===========================")
	
	init_idle()

func init_idle() -> void:
	actor.animations.play(state_animation)
	enter_callback.call()
	
	if use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		idle_comp.start()
		bb["can_idle"] = true
		bb["can_patrol"] = false

func process_physics(_delta: float) -> State:
	actor.velocity.x = 0
	
	if use_behavior_tree:
		pass
	
	if use_parent_logic:
		return handle_physics.call(_delta)

	return null

func process_frame(delta: float) -> State:
	if use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		idle_comp.update(delta)
		
		if not idle_comp.is_active:
			bb["has_collided"] = false
			bb["can_idle"] = true
			bb["can_patrol"] = true
			bb["force_idle"] = false

	if use_parent_logic:
		return handle_frame.call(delta)

	return null

func process_input(event: InputEvent) -> State:
	return handle_input.call(event)
