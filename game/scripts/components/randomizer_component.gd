class_name RandomizerComponent
extends Node

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@onready var actor: Node = get_node_or_null(actor_path)

# Script Variables
var _timers : Dictionary = {}

func randomizer(id: String, chance: float, interval: float, delta: float) -> bool:
	if interval <= 0:
		if enable_debug:
			print(actor.name, " RandomizerComponent entered but interval value 0.")
		return false
	
	if not _timers.has(id):
		_timers[id] = 0.0

	_timers[id] += delta
	if _timers[id] >= interval:
		_timers[id] = 0.0
		var roll : float = randf() * 100.0
		var success : bool = roll < chance
		if enable_debug:
			print(actor.name, " | RandomizerComponent: Id:", id, " | Roll Value:", roll, " | Chance: ", chance, " | Success: ", success)
		return success

	return false
