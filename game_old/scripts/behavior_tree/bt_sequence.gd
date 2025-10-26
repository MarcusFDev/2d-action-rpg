extends BTNode

func tick(actor: Node, blackboard_node: Node) -> BTResult:
	for child: Node in get_children():
		if child is BTNode:
			var result: BTResult = child.tick(actor, blackboard_node)
			match result:
				BTResult.FAILURE:
					return BTResult.FAILURE
				BTResult.RUNNING:
					return BTResult.RUNNING
				BTResult.SUCCESS:
					continue
	return BTResult.SUCCESS
