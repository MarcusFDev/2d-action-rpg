class_name BTNode
extends Node

enum BTResult {
	SUCCESS,
	FAILURE,
	RUNNING
}

var blackboard: Dictionary

func tick(_actor: Node, _blackboard_node: Node) -> BTResult:
	return BTResult.FAILURE
