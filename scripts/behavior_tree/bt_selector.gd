class_name BTSelector
extends BTNode

var children: Array = []

func _init(_children: Array):
	children = _children

func tick(actor: Node, blackboard: Dictionary) -> int:
	for child in children:
		var result = child.tick(actor, blackboard)
		match result:
			BTNode.BTResult.SUCCESS:
				return BTNode.BTResult.SUCCESS
			BTNode.BTResult.RUNNING:
				return BTNode.BTResult.RUNNING
			BTNode.BTResult.FAILURE:
				continue
	return BTNode.BTResult.FAILURE
