extends Node

func restart_level() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
