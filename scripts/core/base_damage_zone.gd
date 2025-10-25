# BaseDamageZone.gd
class_name BaseDamageZone
extends Area2D

@export var damage: int = 1  # Default damage

func _ready() -> void:
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", _on_body_entered)

#func _ready() -> void:
	#connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	
	apply_damage(body)

func apply_damage(body: Node) -> void:
	# Can be overridden for custom logic
	body.take_damage(damage, global_position)
