extends Area2D

func _ready():
	print("Damage Zone ready")
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	print("Something entered DamageZone:", body.name)
	if not body.is_in_group("player"):
		return
		
	var enemy = get_parent()
	if "damage" in enemy:
		var damage = enemy.damage
		body.take_damage(damage)
		print("Player Took", damage, "damage from", enemy.name)
