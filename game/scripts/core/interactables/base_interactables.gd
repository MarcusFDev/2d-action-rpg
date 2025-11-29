class_name BaseInteractables
extends Area2D

signal actor_can_interact(actor: Node)
signal actor_cannot_interact(actor: Node)

## Determines which types of actors are allowed to interact with this Interaction. [br]
## Options: [b]PLAYER[/b], [b]ENEMY[/b], or [b]BOTH[/b].
@export var interact_permission: InteractPermission = InteractPermission.PLAYER
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

enum InteractPermission {
	## Allow ONLY the Player Group to interact with this Interaction.
	PLAYER,
	## Allow ONLY the Enemy Group to interact with this Interaction.
	ENEMY,
	## Allow BOTH Player & Enemy Groups to interact with this Interaction.
	BOTH
}

func actor_entered(actor: Node) -> void:
	if check_permission(actor):
		if enable_debug:
			print("Actor Allowed: ", actor.name)
		emit_signal("actor_can_interact", actor)
	else:
		if enable_debug:
			print("Actor Not Allowed: ", actor.name)
		emit_signal("actor_cannot_interact", actor)

func check_permission(actor: Node) -> bool:
	match interact_permission:
		InteractPermission.PLAYER:
			return actor.is_in_group("player")
		InteractPermission.ENEMY:
			return actor.is_in_group("enemy")
		InteractPermission.BOTH:
			return actor.is_in_group("player") or actor.is_in_group("enemy")
	
	return false
