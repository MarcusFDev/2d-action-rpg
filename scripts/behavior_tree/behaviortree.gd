class_name BehaviorTree

var root: BTNode
var blackboard: Dictionary
var actor: Node

func _init(_root: BTNode, _blackboard: Dictionary, _actor: Node) -> void:
	root = _root
	blackboard = _blackboard
	actor = _actor

func tick() -> void:
	if root and blackboard and actor:
		root.tick(actor, blackboard)
