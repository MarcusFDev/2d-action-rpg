class_name IdleTimerComponent
extends Node

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
@export_group("Idle Options")
## Determines the minimum time a entity can be idle for.[br]
## [b]Tip:[/b] Can exceed 5 seconds with manual input.[br] 
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var min_idle_time: float = 1.0
## Determines the maximum time a entity can be idle for.[br]
## [b]Tip:[/b] Can exceed 5 seconds with manual input.[br] 
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var max_idle_time: float = 3.0

@export_group("Randomize Idle Options")
## Determines how often the component checks whether the entity should randomly enter an idle state. [br]
## [b]Tip:[/b] Larger values make random idle checks less frequent. [br]
## [b]Note:[/b] Setting to [code]0[/code] disables random idle checks entirely.
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var idle_interval: float = 0
## Determines the percentage chance (0–100%) that the entity will decide to idle each time a random check occurs. [br]
## [b]Note:[/b] Low values make random idling rare and natural; higher values increase frequency. [br]
@export_range(0, 100, 1, "suffix:%") var idle_chance: float = 0

# Script Variables
var actor: Node
var timer: float = 0.0
var check_timer: float = 0.0
var target_time: float = 1.0
var is_active: bool = false

func _ready() -> void:
	actor = get_node_or_null(actor_path)

func start() -> void:
	timer = 0.0
	check_timer = 0.0
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
			print(actor.name, " Idle Timer completed.")

func randomize_idle(delta: float) -> bool:
	if idle_interval <= 0:
		return false

	check_timer += delta
	if check_timer >= idle_interval:
		check_timer = 0.0
		if randf() < idle_chance / 100.0:
			if enable_debug:
				print(actor.name, " decided to randomly idle.")
			return true
	return false
