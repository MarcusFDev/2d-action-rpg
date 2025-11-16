class_name HealState
extends State

## Assign the parent entity to the state.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("State Settings")
## Determines the animation that plays during the Heal State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var state_animation : String
## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_parent_logic: bool = false
@export var use_behavior_tree: bool = false

# Script Variables
@onready var actor: Node = get_node_or_null(actor_path)

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
	init_heal()

func init_heal() -> void:
	actor.animations.play(state_animation)

	if enable_debug:
		print(
		"===========================\n",
		"HealState entered by: ", actor.name, "\n",
		"===========================")

func process_physics(delta: float) -> State:
	if use_parent_logic:
		return handle_physics.call(delta)
	return null

func process_frame(delta: float) -> State:
	if use_parent_logic:
		return handle_frame.call(delta)
	return null

func process_input(event: InputEvent) -> State:
	if use_parent_logic:
		return handle_input.call(event)
	return null
