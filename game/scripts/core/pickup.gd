class_name PickUpClass
extends Area2D

## Determines which types of actors are allowed to interact with this pickup-able. [br]
## Options: [b]PLAYER[/b], [b]ENEMY[/b], or [b]BOTH[/b].
@export var interact_permission: InteractPermission = InteractPermission.PLAYER
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

var pickup_data: Dictionary = {}

enum InteractPermission {
	## Allow ONLY the Player Group to interact with this item.
	PLAYER,
	## Allow ONLY the Enemy Group to interact with this item.
	ENEMY,
	## Allow BOTH Player & Enemy Groups to interact with this item.
	BOTH
}

func actor_entered(actor: Node) -> void:
	if enable_debug:
		print(actor.name, " has entered.")
	match interact_permission:
		InteractPermission.PLAYER:
			if not actor.is_in_group("player"):
				return
				
		InteractPermission.ENEMY:
			if not actor.is_in_group("enemy"):
				return
		
		InteractPermission.BOTH:
			pass
	
	var receiver: Node = actor.get_node_or_null("Components/PickUpReceiverComponent")
	if enable_debug:
		print(actor.name, " has got ", receiver)
	if receiver and receiver.has_method("apply_pickup"):
		receiver.apply_pickup(pickup_data)
		queue_free()
