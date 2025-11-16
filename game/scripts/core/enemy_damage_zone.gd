extends BaseDamageZone
#
#func _ready() -> void:
	#connect("body_entered", _on_body_entered)
#
#func _on_body_entered(body: Node) -> void:
	#if not body.is_in_group("player"):
		#return
		#
	#var enemy: Node = get_parent()
	#if "damage" in enemy:
		#damage = enemy.damage
		#body.take_damage(damage, enemy.global_position)
		#print("Enemy Damage Zone | The Player Took ", damage, " damage from a ", enemy.name)
		#
		#if enemy.has_method("trigger_attack"):
			#enemy.trigger_attack()
