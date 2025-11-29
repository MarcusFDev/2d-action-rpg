class_name ItemPickUp
extends BaseInteractables

var item_data: Dictionary = {}

func _ready() -> void:
	connect("actor_can_interact", on_pickup)

func on_pickup(actor: Node) -> void:
	var perm_comp: Node = actor.get("pickup_permission_comp")
	if perm_comp:
		actor.pickup_permission_comp.apply_pickup(item_data)
	elif actor.has_method("pickup_received"):
		actor.pickup_received(item_data)
	else:
		if enable_debug:
			print(actor.name, " has no PickUpPermissionComponent and no pickup_received() method.")
	
	queue_free()
