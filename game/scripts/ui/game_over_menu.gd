class_name GameOverMenu
extends Control

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

func _ready() -> void:
	SignalBus.actor_died.connect(check_actor)

func check_actor(signal_actor: Node) -> void:
	if signal_actor.is_in_group("player"):
		Engine.time_scale = 0
		Global.ui_manager.on_game_over_menu()
		if enable_debug:
			print("GameOverMenu | Game has ended.")

func on_restart_btn() -> void:
	Global.game_manager.on_restart_level()
	if enable_debug:
		print("GameOverMenu | Restart Game button press detected.")

func on_main_menu_btn() -> void:
	Global.game_manager.on_main_menu()
	if enable_debug:
		print("GameOverMenu | Main Menu button press detected.")
