class_name MoveState
extends State

## Determines the animation that plays during the Move State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var move_animation: String
## Determines if entity can randomly idle during movement. [br]
## [b]Note:[/b] Only impacts BehaviorTree driven entities. [br]
## [b]Tip:[/b] Detailed settings found in  [code]IdleTimerComponent[/code].
@export var use_random_idle: bool = false
## Determines whether the entity's animation flips horizontally while moving using  [code]flip_h[/code].[br]
## [b]Note:[/b] Useful to set  [code]false[/code]  for symmetric & direction-agnostic entities.
@export var use_behavior_tree: bool = false
## Determines whether this state uses parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all parent logic settings are ignored.
@export var use_parent_logic: bool = false
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@onready var edge_detector_component: Node = $"../../Components/EdgeDetectorComponent"
@onready var idle_timer_component: Node = $"../../Components/IdleTimerComponent"
@onready var movement_component: Node = $"../../Components/MovementComponent"

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
	init_move()
	
func init_move() -> void:
	parent.animations.play(move_animation)
	enter_callback.call()

	if enable_debug:
		print(
			"\n===== Move State: ===== \n", parent,
			"\nAnimation playing:", move_animation)

func process_physics(delta: float) -> State:
	if use_parent_logic:
		return handle_physics.call(delta)
	
	if use_behavior_tree:
		var bb: Dictionary = parent.get_blackboard()
		direction = bb["move_direction"]
	
	movement_component.set_direction(Vector2(direction, 0))
	movement_component.apply(delta)

	return null

func process_frame(delta: float) -> State:
	if use_behavior_tree:
		var move_dir : int = edge_detector_component.update(delta)
		var bb : Dictionary = parent.get_blackboard()
		if move_dir != 0:
			direction = move_dir
			bb["move_direction"] = direction
			bb["has_collided"] = true
		else:
			bb["has_collided"] = false
	
	if use_random_idle:
		var bb: Dictionary = parent.get_blackboard()
		if idle_timer_component.randomize_idle(delta):
			idle_timer_component.start()
			bb["force_idle"] = true
			bb["can_patrol"] = false

		if idle_timer_component.is_active:
			idle_timer_component.update(delta)
		else:
			bb["force_idle"] = false
			bb["can_patrol"] = true

	if use_parent_logic:
		return handle_frame.call(delta)
	
	return null
