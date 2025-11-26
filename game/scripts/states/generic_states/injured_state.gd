class_name InjuredState
extends State

## Assign the parent entity to the state.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("State Settings")
## Determines the animation that plays during the Hurt State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var state_animation : String
## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_parent_logic: bool = false
@export var use_behavior_tree: bool = false

@export_group("Component Paths")
@export var health_component_path: NodePath

# Script Variables
@onready var actor: Node = get_node_or_null(actor_path)
@onready var health_comp: Node = get_node_or_null(health_component_path)

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

var animation_finished: bool
var amount: float = 0.0

func enter() -> void:
	super.enter()
	if enable_debug:
		print(
		"===========================\n",
		"InjuredState entered by: ", actor.name, "\n",
		"===========================")
	
	init_injured()

func init_injured() -> void:
	actor.animations.play(state_animation)
	animation_finished = false
	
	if use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		bb["locked"] = true

func process_physics(delta: float) -> State:
	if health_comp:
		health_comp.lose_health(amount)

	if use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		bb["force_injured"] = false
		bb["locked"] = false

	if use_parent_logic:
		return handle_physics.call(delta)

	return null
	
func process_frame(delta: float) -> State:
	if use_parent_logic:
		return handle_frame.call(delta)
	return null

func process_input(event: InputEvent) -> State:
	if use_parent_logic:
		if animation_finished:
			return handle_input.call(event)
	return null

func on_animation_finished() -> void:
	if actor.animations.animation == state_animation:
		if enable_debug:
			print(actor.name, " | InjuredState: Animation finished.")
		animation_finished = true

func exit() -> void:
	if enable_debug:
		print(actor.name, " | InjuredState exited.")
