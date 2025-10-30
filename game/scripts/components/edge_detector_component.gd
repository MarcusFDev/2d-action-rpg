class_name EdgeDetectorComponent
extends Node

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Assigns the  [code]RayCast2D[/code]  node used to detect collisions on the [b]right side[/b] of the entity.[br]
@export var raycast_right_path: NodePath
## Assigns the  [code]RayCast2D[/code]  node used to detect collisions on the [b]left side[/b] of the entity.[br]
@export var raycast_left_path: NodePath
## Determines the delay time that the  [code]RayCast2D[/code]  detects a collision.[br]
## [b]Tip:[/b] Can exceed 3 seconds with manual input.[br] 
@export_range(0, 3, 0.1, "suffix:s", "or_greater") var delay_time: float = 0.2
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

# Script Variables
var actor: Node
var ray_left: RayCast2D
var ray_right: RayCast2D
var delay_timer: float = 0.0

func _ready() -> void:
	ray_left = get_node_or_null(raycast_left_path)
	ray_right = get_node_or_null(raycast_right_path)
	actor = get_node_or_null(actor_path)
	
func update(delta: float) -> int:
	if delay_timer > 0:
		delay_timer -= delta
		return 0
	
	var move_dir : int = 0

	if ray_right and ray_right.is_colliding():
		move_dir = -1
		delay_timer = delay_time
		if enable_debug:
			print("Edge detector:", actor.name, " hit right wall.")

	elif ray_left and ray_left.is_colliding():
		move_dir = 1
		delay_timer = delay_time
		if enable_debug:
			print("Edge detector:", actor.name, " hit left wall.")
	
	return move_dir
