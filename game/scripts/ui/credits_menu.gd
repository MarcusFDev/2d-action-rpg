class_name CreditsMenu
extends Control

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

func on_back_btn() -> void:
	Global.ui_manager.on_back_btn()
