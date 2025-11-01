class_name MovementComponent
extends Node

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
## Determines entity movement speed. [br]
## [b]Note:[/b] Can exceed 200 with manual input.
@export_range(0, 200, 1, "suffix:px/s", "or_greater") var move_speed: float = 0

# Script Variables
var actor: Node
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	actor = get_node_or_null(actor_path)

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func apply(_delta: float) -> void:
	if enable_debug:
		print("MovementComponent: ", actor.name, " | Direction: ", direction, " | Speed: ", move_speed, " | Velocity X before move: ", actor.velocity.x)
	actor.velocity = direction * move_speed
	actor.move_and_slide()
