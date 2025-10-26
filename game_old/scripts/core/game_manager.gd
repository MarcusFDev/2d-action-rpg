extends Node

@onready var hud: Control = null

var score: int = 0

func add_point() -> void:
	score += 1
	print("Your Score is: ", score)
	hud.update_score(score)

func restart_level() -> void:
	score = 0
	Engine.time_scale = 1
	get_tree().reload_current_scene()
