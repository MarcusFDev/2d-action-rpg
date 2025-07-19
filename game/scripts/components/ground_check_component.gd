class_name GroundCheckComponent
extends Node

@export var actor_path: NodePath
@export var blackboard_path: NodePath
@export var key_name: String = "is_grounded"

var actor: CharacterBody2D
var blackboard: Node

func _ready() -> void:
	actor = get_node_or_null(actor_path)
	blackboard = get_node_or_null(blackboard_path)

func _physics_process(_delta: float) -> void:
	if actor and blackboard:
		var grounded = actor.is_on_floor()
		blackboard.set_value(key_name, grounded)
