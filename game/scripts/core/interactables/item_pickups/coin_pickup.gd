class_name CoinPickUp
extends ItemPickUp

## Determines the value that this coin provides. [br]
## [b]Note:[/b] Can exceed a value of 10 with manual input.[br]
@export_range(0, 10, 1, "suffix:Coins", "or_greater") var coin_amount: float

func _enter_tree() -> void:
	item_data = {
		"type": "currency",
		"source": "coin",
		"amount": coin_amount
	}
