class_name PickUpPermissionComponent
extends Component

signal pickup_received(data: Dictionary)

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
## Determines whether this entity is allowed to receive healing pickups. [br]
## [b]Tip:[/b] Disable this for actors that should ignore health-restoring items.
@export_group("Enable Health Pickup", "export_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_health_pickup: bool = false

@export var export_allow_heart_crystals: bool = false

@onready var actor: Node = get_node_or_null(actor_path)

func apply_pickup(data: Dictionary) -> void:
	if not data.has("type"):
		if enable_debug:
			print(actor.name, " PickUpPermissionsComponent: Data does not contain 'type'.")
		return
	if not data.has("source"):
		if enable_debug:
			print(actor.name, " PickUpPermissionsComponent: Data does not contain 'source'.")
		return
	
	match data["type"]:
		"heal":
			if export_enable_health_pickup:
				match data["source"]:
					"heart_crystal":
						if export_allow_heart_crystals:
							if enable_debug:
								print(actor.name, " PickUpPermissionsComponent: HeartCrystal Picked Up.")
							emit_signal("pickup_received", data)
