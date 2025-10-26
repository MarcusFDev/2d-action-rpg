# hud.gd
# 
# This script is responsible for displaying and updating the user interface (UI) visuals,
# such as score animations and labels. It does not contain or handle any game logic.
# 
# Dependencies:
# - Expects 'game_manager.gd' to manage and emit changes.

extends Control

@onready var hearts: Array[AnimatedSprite2D] = [
	$HealthBar/Heart1,
	$HealthBar/Heart2,
	$HealthBar/Heart3,
	$HealthBar/Heart4,
	$HealthBar/Heart5,
	$HealthBar/Heart6,
	$HealthBar/Heart7,
	$HealthBar/Heart8,
	$HealthBar/Heart9
	]
@onready var coin_animation: AnimatedSprite2D = $CoinCounter/Coin
@onready var score_label: Label = $CoinCounter/ScoreLabel

func _ready() -> void:
	GameManager.hud = self
	# Dynamically initialize hearts based on current player health
	var player : CharacterBody2D = get_tree().get_nodes_in_group("player").front() as CharacterBody2D
	if player:
		_init_hearts(player.current_health)

func _init_hearts(current_health: int) -> void:
	for i: int in hearts.size():
		hearts[i].visible = i < current_health

func update_score(new_score: int) -> void:
	coin_animation.play("gain_coin")
	score_label.text = "x " + str(new_score)

func update_health(old_health: int, new_health: int) -> void:
	if new_health < old_health:
		for i: int in range(old_health - 1, new_health -1, -1):
			if i >= 0 and i < hearts.size():
				hearts[i].play("lose_health")
	elif new_health > old_health:
		for i: int in range(old_health, new_health):
			if i >= 0 and i < hearts.size():
				hearts[i].visible = true
				hearts[i].play("gain_health")
