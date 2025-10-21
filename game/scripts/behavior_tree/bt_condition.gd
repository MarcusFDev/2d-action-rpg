extends BTNode

@export var condition_key: String
@export var expected_value: Variant = true

func tick(_actor: Node, blackboard_node: Node) -> BTResult:
	var actual_value: Variant = blackboard_node.get_value(condition_key)
	if actual_value == expected_value:
		return BTResult.SUCCESS
	return BTResult.FAILURE
