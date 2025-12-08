@icon("uid://dk648n4k6swil")
class_name InputManager
extends Node

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

# ===============================
# ==== Manager Intialization ====
# ===============================

func _enter_tree() -> void:
	Global.input_manager = self

static func is_jump_pressed() -> bool:
	return Input.is_action_just_pressed("jump")

static func get_movement_axis() -> float:
	return Input.get_axis("move_left", "move_right")

static func is_attack_pressed() -> bool:
	return Input.is_action_just_pressed("attack")

static func is_pause_pressed() -> bool:
	return Input.is_action_just_pressed("pause")
