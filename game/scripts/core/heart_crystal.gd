extends Area2D

@export var health_amount: int = 1
var game_manager: Node = GameManager

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		if body.current_health < body.max_health:
			body.add_health(health_amount)
			queue_free()
