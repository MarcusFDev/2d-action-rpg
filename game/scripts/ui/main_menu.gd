class_name MainMenu
extends Control

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

func on_play_btn() -> void:
	Global.ui_manager.on_level_pick_menu()
	if enable_debug:
		print("MainMenu | Play button press detected.")

func on_settings_btn() -> void:
	Global.ui_manager.on_settings_menu()
	if enable_debug:
		print("MainMenu | Settings button press detected.")

func on_credits_btn() -> void:
	Global.ui_manager.on_credits_menu()
	if enable_debug:
		print("MainMenu | Credits button press detected.")

func on_quit_btn() -> void:
	Global.game_manager.on_game_exit()
	if enable_debug:
		print("MainMenu | Game Exit button press detected.")
