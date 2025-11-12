class_name RandomizerComponent
extends Node

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
## Determines the cooldown time in seconds applied after a successful  [code]randomizer[/code]  trigger. [br]
## [b]Note:[/b] While the cooldown is active, no new randomization attempts can succeed. [br]
## [b]Tip:[/b] Set this value to  [code]0.0[/code]  to disable cooldown behavior entirely.
@export_range(0.0, 10.0, 0.1, "suffix:s") var randomizer_cooldown: float = 0.0

@onready var actor: Node = get_node_or_null(actor_path)

# Script Variables
var _timers : Dictionary = {}

func randomizer(id: String, chance: float, interval: float, delta: float) -> bool:
	if interval <= 0:
		if enable_debug:
			print(actor.name, " RandomizerComponent entered but interval value 0.")
		return false
	
	if not _timers.has(id):
		_timers[id] ={
			"interval": 0.0,
			"cooldown": 0.0
		}
	
	var timer_data: Variant = _timers[id]
	
	if timer_data["cooldown"] > 0.0:
		timer_data["cooldown"] -= delta
		_timers[id] = timer_data
		return false
	
	timer_data["interval"] += delta
	if timer_data["interval"] >= interval:
		timer_data["interval"] = 0.0
		var roll : float = randf() * 100.0
		var success : bool = roll < chance
		
		if enable_debug:
			print(
				actor.name, " | RandomizerComponent: Id:", id,
				" | Roll Value:", roll,
				" | Chance: ", chance,
				" | Success: ", success)
		
		if success and randomizer_cooldown > 0.0:
			timer_data["cooldown"] = randomizer_cooldown
		
		_timers[id] = timer_data
		return success
	
	_timers[id] = timer_data
	return false
