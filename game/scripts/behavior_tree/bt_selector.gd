extends BTNode

func tick(actor: Node, blackboard_node: Node) -> BTResult:
	for child in get_children():
		if child is BTNode:
			var result = child.tick(actor, blackboard_node)
			match result:
				BTResult.SUCCESS:
					return BTResult.SUCCESS
				BTResult.RUNNING:
					return BTResult.RUNNING
				BTResult.FAILURE:
					continue
	return BTResult.FAILURE
