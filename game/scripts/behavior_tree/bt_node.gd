class_name BTNode
extends Node

enum BTResult {
	SUCCESS,
	FAILURE,
	RUNNING
}

var blackboard: Dictionary

func tick(actor: Node, blackboard_node: Node) -> BTResult:
	return BTResult.FAILURE
