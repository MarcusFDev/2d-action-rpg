extends Node

var data := {}

func set_value(key: String, value):
	data[key] = value

func get_value(key: String, default=null):
	return data.get(key, default)

func has(key: String) -> bool:
	return data.has(key)
