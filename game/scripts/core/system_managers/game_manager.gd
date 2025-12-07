extends Node

# ===============================
# ===== Game Manager Script =====
# ===============================

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

#Script Variables
var current_scene: String
var previous_scene: String

func _ready() -> void:
	var scene: Variant = get_tree().current_scene
	if scene:
		current_scene = scene.scene_file_path

func change_scene(path: String) -> void:
	previous_scene = current_scene
	current_scene = path

	get_tree().change_scene_to_file(path)

	if enable_debug:
		print("GameManager | Scene changed to:", path)

# ==============================
# ==== Menu Button Handling ====
# ==============================

func on_main_menu() -> void:
	Engine.time_scale = 1
	change_scene("res://scenes/ui/main_menu.tscn")

func on_level_pick_menu() -> void:
	Engine.time_scale = 1
	change_scene("res://scenes/ui/level_pick_menu.tscn")

func on_settings_menu() -> void:
	Engine.time_scale = 1
	change_scene("res://scenes/ui/settings_menu.tscn")

func on_credits_menu() -> void:
	Engine.time_scale = 1
	change_scene("res://scenes/ui/credits_menu.tscn")

func on_back_btn() -> void:
	change_scene(previous_scene)

func on_restart_level() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	if enable_debug:
		print("GameManager | Reloading Game scene.")

func on_game_exit() -> void:
	get_tree().quit()
	if enable_debug:
		print("GameManager | Game shutting down.")
