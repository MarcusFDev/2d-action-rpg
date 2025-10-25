class_name BTNode

enum BTResult {
	SUCCESS,
	FAILURE,
	RUNNING
}

func tick(_actor: Node, _blackboard_node: Dictionary) -> int:
	return BTResult.FAILURE
