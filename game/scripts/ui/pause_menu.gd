class_name PauseMenu
extends Control

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

func _unhandled_input(_event: InputEvent) -> void:
	if InputManagerClass.is_pause_pressed():
		Global.ui_manager.on_pause_menu()
		if enable_debug:
			print("PauseMenu | Pause button press detected.")

func on_resume_btn() -> void:
	Global.ui_manager.on_pause_menu()
	Engine.time_scale = 1
	if enable_debug:
		print("PauseMenu | Resume button press detected.")

func on_restart_btn() -> void:
	Global.game_manager.on_restart_level()
	if enable_debug:
		print("PauseMenu | Restart Game button press detected.")

func on_options_btn() -> void:
	Global.ui_manager.on_settings_menu()
	if enable_debug:
		print("PauseMenu | Options button press detected.")
	
func on_main_menu_btn() -> void:
	Global.ui_manager.on_main_menu()
	if enable_debug:
		print("PauseMenu | Main Menu button press detected.")
