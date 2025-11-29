class_name HeartCrystalPickUp
extends ItemPickUp

## Determines the value of health this heart crystal provides. [br]
## [b]Note:[/b] Can exceed 10 hearts with manual input.[br]
@export_range(0, 10, 1, "suffix:Hearts", "or_greater") var heal_amount: float

func _enter_tree() -> void:
	item_data = {
		"type": "heal",
		"source": "heart_crystal",
		"amount": heal_amount
	}
