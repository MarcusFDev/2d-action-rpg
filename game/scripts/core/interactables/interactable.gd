class_name Interactable
extends BaseInteractables

## Note: Shelved for future Development.

#@export var destroy_on_interact: bool = false
#
#func _ready() -> void:
	#connect("actor_can_interact", on_interact)
#
#func on_interact(actor: Node) -> void:
	#if destroy_on_interact:
		#queue_free()
