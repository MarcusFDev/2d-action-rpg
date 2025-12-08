class_name PlayerHUD
extends Control

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

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

var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_warning("PlayerHUD: No player found in group 'player'.")
		return

	var health_component: Component = player.get_node_or_null("Components/HealthComponent")
	if health_component:
		health_component.update_health.connect(update_health_bar)
		init_health_bar(health_component.current_health)
	else:
		push_warning("PlayerHUD: Player has no HealthComponent.")

func init_health_bar(current_health: float) -> void:
	for i: float in hearts.size():
		hearts[i].visible = i < current_health

func update_health_bar(old_health: float, new_health: float) -> void:
	if new_health < old_health:
		for i: float in range(old_health - 1, new_health -1, -1):
			if i >= 0 and i < hearts.size():
				hearts[i].play("lose_health")
	elif new_health > old_health:
		for i: float in range(old_health, new_health):
			if i >= 0 and i < hearts.size():
				hearts[i].visible = true
				hearts[i].play("gain_health")
