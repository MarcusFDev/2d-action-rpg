class_name PickUpPermissionResource
extends Resource

## Determines whether this entity is allowed to pickup any items. [br]
## [b]Tip:[/b] Disable this for actors that should ignore items.
@export var enable_item_pickup: bool = true

@export_category("Advanced Settings")
@export_group("Toggle Advanced Controls", "toggle_")
## Provides access to more refined item pickup toggles. [br]
## [b]Note:[/b] While disabled all items are considered pickup-able unless item pickup is also disabled.
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var toggle_advanced_controls: bool = false

@export_subgroup("Health Items", "toggle_")
## Determines whether this entity is allowed to pickup HeartCrystals. [br]
## [b]Tip:[/b] Disable this for actors that should ignore these items.
@export var toggle_allow_heart_crystals: bool = false

@export_subgroup("Currency Items", "toggle_")
## Determines whether this entity is allowed to pickup Coins. [br]
## [b]Tip:[/b] Disable this for actors that should ignore these items.
@export var toggle_allow_coins: bool = false

var allowed: Array = []

func rebuild_allowed() -> void:
	allowed.clear()
	
	if not enable_item_pickup:
		return
	
	if not toggle_advanced_controls:
		allowed = ["heart_crystal", "coin"]
		return
	
	if toggle_allow_heart_crystals:
		allowed.append("heart_crystal")

	if toggle_allow_coins:
		allowed.append("coin")
