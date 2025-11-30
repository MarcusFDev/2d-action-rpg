class_name HeartCrystalPickUp
extends ItemPickUp

## Determines the value of health this heart crystal provides. [br]
## [b]Note:[/b] Can exceed 10 hearts with manual input.[br]
@export_range(0, 10, 1, "suffix:Hearts", "or_greater") var heal_amount: float

func _enter_tree() -> void:
	item_data = {
		"item_id": "heart_crystal",
		"item_type": "health",
		"item_value": heal_amount
	}
