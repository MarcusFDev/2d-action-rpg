# hud.gd
# 
# This script is responsible for displaying and updating the user interface (UI) visuals,
# such as score animations and labels. It does not contain or handle any game logic.
# 
# Dependencies:
# - Expects 'game_manager.gd' to manage and emit changes.

extends Control

@onready var hearts:= [$HealthBar/Heart1, $HealthBar/Heart2, $HealthBar/Heart3]
@onready var coin_animation: AnimatedSprite2D = $CoinCounter/Coin
@onready var score_label: Label = $CoinCounter/ScoreLabel


func update_score(new_score: int) -> void:
	coin_animation.play("gain_coin")
	score_label.text = "x " + str(new_score)
