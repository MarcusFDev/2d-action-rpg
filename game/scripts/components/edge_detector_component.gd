class_name EdgeDetectorComponent
extends Node

@export var actor_path: NodePath
## Assigns the  [code]RayCast2D[/code]  node used to detect collisions on the [b]right side[/b] of the entity.[br]
@export var raycast_right_path: NodePath
## Assigns the  [code]RayCast2D[/code]  node used to detect collisions on the [b]left side[/b] of the entity.[br]
@export var raycast_left_path: NodePath
@export var delay_time: float = 0.15
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

var actor: Node
var blackboard: Dictionary
var ray_left: RayCast2D
var ray_right: RayCast2D
var delay_timer: float = 0.0

func _ready() -> void:
	ray_left = get_node_or_null(raycast_left_path)
	ray_right = get_node_or_null(raycast_right_path)
	actor = get_node_or_null(actor_path)
	
	if actor and actor.has_method("get_blackboard"):
		blackboard = actor.get_blackboard()
	
	if blackboard:
		blackboard["hit_wall"] = false
		blackboard["move_direction"] = 1
		
		if enable_debug:
			print(actor, "Edge detector:", blackboard["move_direction"])

func apply(delta: float) -> int:
	return update(delta)
	
func update(delta: float) -> int:
	if delay_timer > 0:
		delay_timer -= delta
		return 0
	
	var hit_wall : bool = false
	var move_dir : int = 0

	if ray_right and ray_right.is_colliding():
		hit_wall = true
		move_dir = -1
		delay_timer = delay_time

		if enable_debug:
			print("Edge detector:", actor, " hit right wall.")

	elif ray_left and ray_left.is_colliding():
		hit_wall = true
		move_dir = 1
		delay_timer = delay_time

		if enable_debug:
			print("Edge detector:", actor, " hit left wall.")
	
	else:
		if blackboard:
			blackboard["hit_wall"] = false
	
	if blackboard:
		blackboard["hit_wall"] = hit_wall
		
		if move_dir != 0:
			blackboard["move_direction"] = move_dir
			if enable_debug:
				print("Edge detector:", actor, "Move Direction:", blackboard["move_direction"])
	
	return move_dir
