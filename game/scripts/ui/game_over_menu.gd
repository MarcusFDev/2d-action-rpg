class_name GameOverMenu
extends Control

## Assign the Player to the GameOverMenu.
@export var player_path: Node
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

func _ready() -> void:
	if not player_path:
		push_error("GameOverMenu | Player not assigned.")
	
	SignalBus.actor_died.connect(check_actor)

func check_actor(actor: Node) -> void:
	if actor == player_path:
		on_game_over()

func on_game_over() -> void:
	visible = true
	Engine.time_scale = 0
	if enable_debug:
		print("GameOverMenu | Game has ended.")

func on_restart_btn() -> void:
	var current_scene: Node = get_tree().current_scene
	if current_scene:
		var scene_path : String = current_scene.scene_file_path
		Engine.time_scale = 1
		get_tree().change_scene_to_file(scene_path)
		if enable_debug:
			print("GameOverMenu | Restart Button pressed. Restarting Level.")

func on_main_menu_btn() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	if enable_debug:
		print("GameOverMenu | Main Menu Button pressed. Returning to Main Menu.")
