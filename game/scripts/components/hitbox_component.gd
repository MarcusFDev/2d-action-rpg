class_name HitBoxComponent
extends Area2D

signal hitbox_entered(hitbox_owner: Node, hurtbox_owner: Node)

## Assign the parent entity to the script.
@export var owner_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")

@onready var hitbox_owner: Node = get_node_or_null(owner_path)

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if area is HurtBoxComponent:
		var hurtbox: Variant = area as HurtBoxComponent
		
		if hurtbox.hurtbox_owner == hitbox_owner:
			return
		
		emit_signal("hitbox_entered", hitbox_owner, hurtbox.hurtbox_owner)
			
		if enable_debug:
			print(hurtbox.hurtbox_owner.name, " | HitBoxComponent: Actor been detected by ", hitbox_owner.name)
