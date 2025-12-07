class_name PauseMenu
extends Control

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

# Script Variables
var paused: bool = false

func _unhandled_input(_event: InputEvent) -> void:
	if InputManagerClass.is_pause_pressed():
		toggle_pause()
		if enable_debug:
			print("PauseMenu | Pause button press detected.")

func toggle_pause() -> void:
	paused = !paused
	
	if paused:
		self.hide()
		Engine.time_scale = 1
		if enable_debug:
			print("PauseMenu | Pause toggled off.")
	else:
		self.show()
		Engine.time_scale = 0
		if enable_debug:
			print("PauseMenu | Pause toggled on.")

func on_resume_btn() -> void:
	toggle_pause()
	if enable_debug:
		print("PauseMenu | Resume button press detected.")

func on_main_menu_btn() -> void:
	GameManager.on_main_menu()
	if enable_debug:
		print("PauseMenu | Main Menu button press detected.")

func on_restart_btn() -> void:
	GameManager.on_restart_level()
	if enable_debug:
		print("PauseMenu | Restart Game button press detected.")
