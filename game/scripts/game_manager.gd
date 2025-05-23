extends Node

var player_health := 3
var score := 0

signal health_changed(health)

@onready var score_label: Label = $CanvasLayer/HUD/CoinCounter/ScoreLabel
@onready var animation: AnimatedSprite2D = $CanvasLayer/HUD/CoinCounter/Coin

func _ready():
	emit_signal("health_changed", player_health)

func add_point():
	animation.play("gain_coin") # Plays animation upon coin increase.
	score += 1
	score_label.text = "x " + str(score)

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
