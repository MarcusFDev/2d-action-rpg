class_name BTSequence
extends BTNode

var children: Array = []

func _init(_children: Array):
	children = _children

func tick(actor: Node, blackboard: Dictionary) -> int:
	for child in children:
		var result = child.tick(actor, blackboard)
		match result:
			BTNode.BTResult.FAILURE:
				return BTNode.BTResult.FAILURE
			BTNode.BTResult.RUNNING:
				return BTNode.BTResult.RUNNING
	return BTNode.BTResult.SUCCESS
