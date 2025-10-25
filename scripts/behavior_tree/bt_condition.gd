class_name BTCondition
extends BTNode

var condition_key: String
var expected_value

func _init(_key: String, _expected_value):
	condition_key = _key
	expected_value = _expected_value

func tick(_actor: Node, blackboard: Dictionary) -> int:
	var actual_value = blackboard.get(condition_key, null)
	if actual_value == expected_value:
		return BTNode.BTResult.SUCCESS
	return BTNode.BTResult.FAILURE
