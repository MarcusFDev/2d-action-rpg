class_name GroundCheckComponent
extends Node

@export var actor_path: NodePath
@export var key_name: String = "is_grounded"
@export var grounded_buffer_time: float = 0.5
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

var actor: Node
var blackboard: Dictionary
var grounded_timer: float = 0.0
var is_grounded_internal: bool = false

var is_grounded: bool:
	get:
		return is_grounded_internal

func _ready() -> void:
	actor = get_node_or_null(actor_path)
	if actor and actor.has_method("get_blackboard"):
		blackboard = actor.get_blackboard()

func apply(delta: float) -> void:
	if not actor:
		return

	var on_floor : bool = actor.is_on_floor()

	if on_floor:
		grounded_timer += delta
		if grounded_timer >= grounded_buffer_time and not is_grounded_internal:
			is_grounded_internal = true
			_update_blackboard(true)
			if enable_debug:
				print(actor.name, " confirmed grounded.")
	else:
		if is_grounded_internal:
			is_grounded_internal = false
			_update_blackboard(false)
			if enable_debug:
				print(actor.name, " lost ground contact.")
		grounded_timer = 0.0

func _update_blackboard(value: bool) ->void:
	if blackboard:
		blackboard[key_name] = value
