class_name HurtBoxComponent
extends Area2D

signal hit_received(hurtbox_owner: Node, hitbox_data: Variant)

## Assign the parent entity to the script.
@export var owner_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

# Script Variables
@onready var hurtbox_owner: Node = get_node(owner_path)

func received_hit(hitbox_owner: Node, hitbox_data: Variant) -> void:
	emit_signal("hit_received", hurtbox_owner, hitbox_data)
	if enable_debug:
		print(hurtbox_owner.name, " | HurtBoxComponent: ", hitbox_owner.name, "'s HitBoxData: ", hitbox_data)
