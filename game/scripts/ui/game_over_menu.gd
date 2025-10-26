extends Control

func on_enter() -> void:
	Engine.time_scale = 0

func _on_restart_button_pressed() -> void:
	var current_scene: Node = get_tree().current_scene
	if current_scene:
		var scene_path : String = current_scene.scene_file_path
		# Unpause the game before restarting
		Engine.time_scale = 1
		get_tree().change_scene_to_file(scene_path)


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
