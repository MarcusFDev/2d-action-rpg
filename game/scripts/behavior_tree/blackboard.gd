extends Node

var data : Dictionary = {}

func set_value(key: String, value: Variant) -> void:
	data[key] = value

func get_value(key: String, default: Variant =null) -> Variant:
	return data.get(key, default)

func has(key: String) -> bool:
	return data.has(key)
