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
@export_group("Enable Health Pickup", "export_hp_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_hp_enable_health_pickup: bool = false
@export var export_hp_allow_heart_crystals: bool = false

## Determines whether this entity is allowed to receive healing pickups. [br]
## [b]Tip:[/b] Disable this for actors that should ignore health-restoring items.
@export_group("Enable Currency Pickup", "export_cur_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_cur_enable_currency_pickup: bool = false
@export var export_cur_allow_coins: bool = false

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
			if export_hp_enable_health_pickup:
				match data["source"]:
					"heart_crystal":
						if export_hp_allow_heart_crystals:
							if enable_debug:
								print(actor.name, " PickUpPermissionsComponent: HeartCrystal Picked Up.")
							emit_signal("pickup_received", data)
		"currency":
			if export_cur_enable_currency_pickup:
				match data["source"]:
					"coin":
						if export_cur_allow_coins:
							if enable_debug:
								print(actor.name, " PickUpPermissionsComponent: Coin Picked Up.")
							emit_signal("pickup_received", data)
