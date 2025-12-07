class_name SettingsMenu
extends Control

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

func on_back_btn() -> void:
	GameManager.on_back_btn()
	if enable_debug:
		print("SettingsMenu | Back button press detected.")
