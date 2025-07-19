class_name BehaviorTree
extends Node

@export var blackboard_node_path: NodePath
@export var actor_node_path: NodePath

var blackboard_node: Node
var actor: Node

func _ready() -> void:
	if blackboard_node_path != null and has_node(blackboard_node_path):
		blackboard_node = get_node(blackboard_node_path)
	if actor_node_path != null and has_node(actor_node_path):
		actor = get_node(actor_node_path)

func _process(delta: float) -> void:
	if get_child_count() == 0:
		return
	
	var root = get_child(0)
	if root is BTNode and blackboard_node and actor:
		root.tick(actor, blackboard_node)
