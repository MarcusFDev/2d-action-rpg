class_name HitBox
extends Area2D

## Assign the parent entity to the script.
@export var owner_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@onready var hitbox_owner: Node = get_node_or_null(owner_path)

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		var hurtbox: Variant = area as HurtBox
		
		if hurtbox.hurtbox_owner == hitbox_owner:
			return
		
		if hitbox_owner.damage:
			var hitbox_data: Variant = hitbox_owner.damage
			hurtbox.received_hit(hitbox_owner, hitbox_data)

			if enable_debug:
				print(hitbox_owner.name, " | HitBox: ", hurtbox.hurtbox_owner.name, "'s HurtBox has been detected.")
				print(hitbox_owner.name, " | HitBox: ", hitbox_owner.name, "'s HitBoxData: ", hitbox_data)
