extends Control

func _ready() -> void:
	var container_path: String = "LevelPanels/VBoxContainer/ScrollContainer/HBoxContainer"
	var container: Node = get_node_or_null(container_path)

	for button: Node in container.get_children():
		var btn_node: Node = button
		var dim_overlay: Node = btn_node.get_node_or_null("DimOverlay")
		var lock_icon: Node = btn_node.get_node_or_null("LockIcon")

		if dim_overlay and lock_icon:
			var is_locked: bool = true
			dim_overlay.visible = is_locked
			lock_icon.visible = is_locked


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_developer_level_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/levels/developer_level.tscn")


func _on_level_1_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")
