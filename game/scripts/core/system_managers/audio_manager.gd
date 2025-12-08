@icon("uid://bjqnfiiqifljl")
class_name AudioManager
extends Node

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

# ===============================
# ==== Manager Intialization ====
# ===============================

func _enter_tree() -> void:
	Global.audio_manager = self
