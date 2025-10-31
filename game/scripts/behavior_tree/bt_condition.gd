class_name BTCondition
extends BTNode

var condition_key: String
var expected_value: Variant

func _init(_key: String, _expected_value: Variant) -> void:
	condition_key = _key
	expected_value = _expected_value

func tick(_actor: Node, blackboard: Dictionary) -> int:
	if condition_key == "random_chance":
		if randf() < float(expected_value):
			return BTNode.BTResult.SUCCESS
		return BTNode.BTResult.FAILURE
	
	var actual_value: Variant = blackboard.get(condition_key, null)
	if actual_value == expected_value:
		return BTNode.BTResult.SUCCESS
	return BTNode.BTResult.FAILURE
