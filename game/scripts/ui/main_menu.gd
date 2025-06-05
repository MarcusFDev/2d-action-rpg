extends Control



func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_picker.tscn")

	
func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_tutorial_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")
