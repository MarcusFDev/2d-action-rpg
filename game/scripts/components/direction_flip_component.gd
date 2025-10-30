class_name DirectionFlipComponent
extends Node

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Assigns the  [code]AnimatedSprite2D[/code]  path to access parent animations.
@export var animations_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

#Script Variables
var actor: Node
var animations: AnimatedSprite2D

func _ready() -> void:
	actor = get_node_or_null(actor_path)
	animations = get_node_or_null(animations_path)

func apply(_delta: float) -> void:
	if actor and animations:
		if actor.velocity.x != 0:
			animations.flip_h = actor.velocity.x < 0
			if enable_debug:
				print(actor.name, " animation flipped.")
