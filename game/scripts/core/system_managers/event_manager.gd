@icon("uid://ckotdynk5obmx")
class_name EventManager
extends Node

@warning_ignore("unused_signal")
signal actor_died(actor: Node)
@warning_ignore("unused_signal")
signal player_spawned(player: Node)
@warning_ignore("unused_signal")
signal level_restart()

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

# ===============================
# ==== Manager Intialization ====
# ===============================

func _enter_tree() -> void:
	Global.event_manager = self
