extends Control
	

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/level_picker.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits_menu.tscn")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
