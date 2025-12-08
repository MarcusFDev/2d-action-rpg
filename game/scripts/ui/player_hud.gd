class_name PlayerHUD
extends Control

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@onready var hearts: Array[AnimatedSprite2D] = [
	$HealthBar/Heart1, $HealthBar/Heart2,
	$HealthBar/Heart3, $HealthBar/Heart4,
	$HealthBar/Heart5, $HealthBar/Heart6,
	$HealthBar/Heart7, $HealthBar/Heart8,
	$HealthBar/Heart9
	]

# Script Variables
var player: CharacterBody2D

func _ready() -> void:
	Global.event_manager.player_spawned.connect(on_player_load)
	Global.event_manager.level_restart.connect(reset_health_bar)

func on_player_load(player_ref: Node) -> void:
	player = player_ref
	if player.health_comp:
		player.health_comp.update_health.connect(update_health_bar)
		init_health_bar(player.health_comp.current_health)
	else:
		for heart: Node in hearts:
			heart.hide()
		push_warning("PlayerHUD | Player has no HealthComponent.")

func reset_health_bar() -> void:
	player = null
	for heart: Node in hearts:
		heart.show()
		heart.stop()

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
				hearts[i].show()
				hearts[i].play("gain_health")
