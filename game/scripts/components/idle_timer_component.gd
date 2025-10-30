class_name IdleTimerComponent
extends Node

@export var actor_path: NodePath
## Determines the minimum time a entity can be idle for.[br]
## [b]Note:[/b] Can exceed 5 seconds with manual input.[br] 
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var min_idle_time: float = 1.0
## Determines the maximum time a entity can be idle for.[br]
## [b]Note:[/b] Can exceed 5 seconds with manual input.[br] 
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var max_idle_time: float = 3.0
@export var enable_debug: bool = false

var actor: Node
var blackboard: Dictionary
var timer : float = 0.0
var target_time : float = 1.0
var is_active : bool = false

func _ready() -> void:
	actor = get_node_or_null(actor_path)
	if actor and actor.has_method("get_blackboard"):
		blackboard = actor.get_blackboard()

func start() -> void:
	timer = 0.0
	target_time = randf_range(min_idle_time, max_idle_time)
	is_active = true
	if blackboard:
		blackboard["can_idle"] = true
		blackboard["can_patrol"] = false
	if enable_debug:
		print(actor, " Idle Timer started for ", target_time, " seconds.")

func update(delta: float) -> void:
	if not is_active:
		return
	timer += delta
	if timer >= target_time:
		is_active = false
		if blackboard:
			blackboard["can_idle"] = true
			blackboard["can_patrol"] = true

		if enable_debug:
			print(actor, "Idle Timer completed.")
