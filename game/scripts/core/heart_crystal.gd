extends Area2D

var game_manager: Node = GameManager

func _on_body_entered(body: CharacterBody2D) -> void:
	game_manager.add_health()
