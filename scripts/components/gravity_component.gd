class_name GravityComponent
extends Node

@export var actor_path: NodePath
@export var gravity: float = 1200.0

var actor: Node
var blackboard: Dictionary = {}

func _ready() -> void:
	actor = get_node_or_null(actor_path)

func set_blackboard(bb: Dictionary) -> void:
	blackboard = bb

func apply(delta: float) -> void:
	if actor == null:
		return
	var is_grounded : bool = false
	if blackboard.has("is_grounded"):
		is_grounded = blackboard["is_grounded"]
	elif actor.has_method("is_on_floor"):
		is_grounded = actor.is_on_floor()
	
	if not is_grounded:
		actor.velocity.y += gravity * delta
