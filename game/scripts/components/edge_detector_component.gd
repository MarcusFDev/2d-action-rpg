class_name EdgeDetectorComponent
extends Node

## Assigns the  [code]RayCast2D[/code]  node used to detect collisions on the [b]right side[/b] of the entity.[br]
@export var raycast_right_path: NodePath
## Assigns the  [code]RayCast2D[/code]  node used to detect collisions on the [b]left side[/b] of the entity.[br]
@export var raycast_left_path: NodePath
@export var delay_time: float = 0.15
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

var ray_left: RayCast2D
var ray_right: RayCast2D
var delay_timer: float = 0.0

func _ready() -> void:
	ray_left = get_node_or_null(raycast_left_path)
	ray_right = get_node_or_null(raycast_right_path)

func update(delta: float) -> int:
	if delay_timer > 0:
		delay_timer -= delta
		return 0

	if ray_right and ray_right.is_colliding():
		delay_timer = 0.15
		if enable_debug:
			print("Edge detector: hit right wall.")
		return -1
	elif ray_left and ray_left.is_colliding():
		delay_timer = 0.15
		if enable_debug:
			print("Edge detector: hit left wall.")
		return 1

	return 0
