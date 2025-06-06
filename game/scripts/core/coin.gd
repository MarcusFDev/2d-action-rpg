extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var game_manager: Node = GameManager

func _on_body_entered(_body: CharacterBody2D) -> void:
	game_manager.add_point()
	animation_player.play("pickup") # Function that removes coin upon player collision.
