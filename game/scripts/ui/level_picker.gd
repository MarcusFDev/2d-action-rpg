extends Control

@onready var dim_overlay: ColorRect = $DimOverlay
@onready var lock_icon: TextureRect = $LockIcon

func set_locked(is_locked: bool) -> void:
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
