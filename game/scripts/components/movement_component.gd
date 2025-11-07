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

@export_group("Randomize Direction")
@export_range(0, 100, 1, "suffix:%") var randomized_chance: float

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)

# Script Variables
var direction: Vector2 = Vector2.ZERO

func randomize_direction(direction: int) -> int:
	var flip_chance: float = randomized_chance / 100.0

	if randf() < flip_chance:
		direction *= -1

	return direction

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func get_direction() -> Vector2:
	return direction

func apply(_delta: float) -> void:
	if enable_debug:
		print("MovementComponent: ", actor.name, " | Direction: ", direction, " | Speed: ", move_speed, " | Velocity X before move: ", actor.velocity.x)
	actor.velocity = direction * move_speed
	actor.move_and_slide()
