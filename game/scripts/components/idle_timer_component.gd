class_name IdleTimerComponent
extends Node

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Determines the minimum time a entity can be idle for.[br]
## [b]Tip:[/b] Can exceed 5 seconds with manual input.[br] 
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var min_idle_time: float = 1.0
## Determines the maximum time a entity can be idle for.[br]
## [b]Tip:[/b] Can exceed 5 seconds with manual input.[br] 
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var max_idle_time: float = 3.0
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

# Script Variables
var actor: Node
var timer : float = 0.0
var target_time : float = 1.0
var is_active : bool = false

func _ready() -> void:
	actor = get_node_or_null(actor_path)

func start() -> void:
	timer = 0.0
	target_time = randf_range(min_idle_time, max_idle_time)
	is_active = true

	if enable_debug:
		print(actor.name, " Idle Timer started for ", target_time, " seconds.")

func update(delta: float) -> void:
	if not is_active:
		return
	timer += delta
	if timer >= target_time:
		is_active = false

		if enable_debug:
			print(actor.name, "Idle Timer completed.")
