class_name DirectionFlipComponent
extends Node

@export var actor_path: NodePath
@export var animations_path: NodePath

var actor: Node
var animations: AnimatedSprite2D

func _ready() -> void:
	actor = get_node_or_null(actor_path)
	animations = get_node_or_null(animations_path)

func apply(_delta: float) -> void:
	if actor and animations:
		if actor.velocity.x != 0:
			animations.flip_h = actor.velocity.x < 0
