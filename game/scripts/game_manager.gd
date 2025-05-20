extends Node

var score := 0
@onready var score_label: Label = $CanvasLayer/HUD/CoinCounter/ScoreLabel
@onready var animation: AnimatedSprite2D = $CanvasLayer/HUD/CoinCounter/Coin

func add_point():
	animation.play("gain_coin") # Plays animation upon coin increase.
	score += 1
	score_label.text = "x " + str(score)
