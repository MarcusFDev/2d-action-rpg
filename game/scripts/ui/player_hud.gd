class_name PlayerHUD
extends Control

@export var actor_path: NodePath
@export var enable_debug: bool = false

@export_category("HUD Settings")

@onready var actor: Node = get_node_or_null(actor_path)
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


func _ready() -> void:
	if not actor:
		push_warning("PlayerHUD: No actor assigned.")
		return

	var health_component: Component = actor.get_node_or_null("Components/HealthComponent")
	if health_component:
		health_component.update_health.connect(update_health_bar)
		init_health_bar(health_component.current_health)
	else:
		push_warning("PlayerHUD: Actor has no HealthComponent.")

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
