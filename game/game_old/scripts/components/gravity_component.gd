class_name GravityComponent
extends Node

@export var actor_path: NodePath
@export var blackboard_path: NodePath
@export var gravity: float = 1200.0

var actor: CharacterBody2D
var blackboard: Node

func _ready() -> void:
	actor = get_node_or_null(actor_path)
	blackboard = get_node_or_null(blackboard_path)

func apply(delta: float) -> void:
	if actor and blackboard:
		var is_grounded: bool = blackboard.get_value("is_grounded", true)
		if not is_grounded:
			actor.velocity.y += gravity * delta
