class_name MoveState
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
## Determines if entity can randomly idle during movement. [br]
## [b]Note:[/b] Only impacts BehaviorTree driven entities. [br]
## [b]Tip:[/b] Detailed settings found in  [code]IdleTimerComponent[/code].
@export var use_random_idle: bool = false

@export_group("Component Paths")
@export var edge_detector_component: NodePath
@export var idle_timer_component: NodePath
@export var movement_component: NodePath

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)
@onready var edge_detector_comp: Node = get_node_or_null(edge_detector_component)
@onready var idle_timer_comp: Node = get_node_or_null(idle_timer_component)
@onready var movement_comp: Node = get_node_or_null(movement_component)

# Script Variables
var direction: int = 0

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
		"MoveState entered by: ", actor.name, "\n",
		"===========================")
	
	init_move()
	
func init_move() -> void:
	actor.animations.play(state_animation)
	enter_callback.call()

func process_physics(delta: float) -> State:
	if use_parent_logic:
		return handle_physics.call(delta)
	
	if use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		direction = bb["move_direction"]
	
	movement_comp.set_direction(Vector2(direction, 0))
	movement_comp.apply(delta)

	return null

func process_frame(delta: float) -> State:
	if use_behavior_tree:
		var move_dir : int = edge_detector_comp.update(delta)
		var bb : Dictionary = actor.get_blackboard()

		if move_dir != 0:
			direction = move_dir
			bb["move_direction"] = direction
			bb["has_collided"] = true
			bb["can_jump"] = true
		else:
			bb["has_collided"] = false
	
	if use_random_idle:
		var bb: Dictionary = actor.get_blackboard()
		if idle_timer_comp.randomize_idle(delta):
			idle_timer_comp.start()
			bb["force_idle"] = true
			bb["can_patrol"] = false

		if idle_timer_comp.is_active:
			idle_timer_comp.update(delta)
		else:
			bb["force_idle"] = false
			bb["can_patrol"] = true

	if use_parent_logic:
		return handle_frame.call(delta)
	
	return null
