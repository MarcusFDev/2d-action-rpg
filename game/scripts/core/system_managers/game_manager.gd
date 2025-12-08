@icon("uid://cxs3tqf8xbusm")
class_name GameManager
extends Node

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

#Script Variables
var current_level: Node = null
var current_level_path: String

# ===============================
# ==== Manager Intialization ====
# ===============================

func _enter_tree() -> void:
	Global.game_manager = self

# ==========================
# ===== Level Handling =====
# ==========================

func load_level(path: String) -> void:
	if current_level != null:
		current_level.queue_free()
		current_level = null
	
	current_level_path = path
	
	var scene_res: Variant = ResourceLoader.load(path)
	if scene_res == null:
		push_error("GameManager | Failed to load level: " + path)
		return
	
	current_level = scene_res.instantiate()
	
	var level_root: Variant = get_tree().root.get_node("Shell/LevelRoot")
	level_root.add_child(current_level)
	
	Global.ui_manager.on_hide_menu()
	
	if enable_debug:
		print("GameManager | Level loaded:", path)

func on_restart_level() -> void:
	if current_level == null:
		push_error("GameManager | No level to restart.")
	
	Global.event_manager.level_restart.emit()
	Engine.time_scale = 1
	load_level(current_level_path)
	
	if enable_debug:
		print("GameManager | Restarting level: ", current_level)

func on_game_exit() -> void:
	get_tree().quit()
	if enable_debug:
		print("GameManager | Game shutting down.")
