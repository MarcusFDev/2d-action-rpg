class_name IdleState
extends State

## Determines the animation that plays during the Idle State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var idle_animation : String
@export var use_behavior_tree: bool = false
## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_parent_logic: bool = false
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@onready var idle_timer_component: Node = $"../../Components/IdleTimerComponent"

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
	init_idle()

func init_idle() -> void:
	parent.animations.play(idle_animation)
	enter_callback.call()
	
	if use_behavior_tree:
		var bb: Dictionary = parent.get_blackboard()
		idle_timer_component.start()
		bb["can_idle"] = true
		bb["can_patrol"] = false
	
	if enable_debug:
		print(
			"\n===== Idle State: ===== \n", parent,
			"\nAnimation playing: ", idle_animation)

func process_physics(_delta: float) -> State:
	parent.velocity.x = 0
	
	if use_behavior_tree:
		pass
	
	if use_parent_logic:
		return handle_physics.call(_delta)

	return null

func process_frame(delta: float) -> State:
	if use_behavior_tree:
		var bb: Dictionary = parent.get_blackboard()
		idle_timer_component.update(delta)
		
		if not idle_timer_component.is_active:
			bb["has_collided"] = false
			bb["can_idle"] = true
			bb["can_patrol"] = true
			bb["force_idle"] = false

	if use_parent_logic:
		return handle_frame.call(delta)

	return null

func process_input(event: InputEvent) -> State:
	return handle_input.call(event)
