extends Control



func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/game.tscn")


func _on_options_btn_pressed() -> void:
	pass # Replace with function body.


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
