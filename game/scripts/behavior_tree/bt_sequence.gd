class_name BTSequence
extends BTNode

var children: Array[BTNode] = []

func _init(_children: Array[BTNode]) -> void:
	children = _children

func tick(actor: Node, blackboard: Dictionary) -> int:
	for child: BTNode in children:
		var result: int = child.tick(actor, blackboard)
		match result:
			BTNode.BTResult.FAILURE:
				return BTNode.BTResult.FAILURE
			BTNode.BTResult.RUNNING:
				return BTNode.BTResult.RUNNING
	return BTNode.BTResult.SUCCESS
