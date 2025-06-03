extends Node

@onready var hud: Control = $"../Interfaces/CanvasLayer/Hud/Hud"

var player_health: int = 3
var score: int = 0

signal health_changed(health)

func _ready():
	emit_signal("health_changed", player_health)

func add_point():
	#animation.play("gain_coin")
	score += 1
	print("Your Score is: ", score)
	hud.update_score(score)
	#score_label.text = "x " + str(score)

func damage_player(amount := 1):
	player_health = max(player_health - amount, 0)
	emit_signal("health_changed", player_health)
	
	if player_health <= 0:
		print("You Died")
		Engine.time_scale = 0.5
		restart_level()

func restart_level():
	player_health = 3
	score = 0
	Engine.time_scale = 1
	emit_signal("health_changed", player_health)
	get_tree().reload_current_scene()
