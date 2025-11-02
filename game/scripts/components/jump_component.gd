class_name JumpComponent
extends Node

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
## Determines in seconds it takes to reach the  [code]jump_height[/code]  value.[br]
## [b]Note:[/b] Can exceed 3 seconds with manual input.[br]
## [b]Warning:[/b] If time value exceeds  [code]jump_height[/code]  value unexpected behavior may occur.
@export_range(0.0, 3.0, 0.1, "or_greater", "suffix:s") var jump_time: float = 0
## Determines the height the entity attempts to reach. [br]
## [b]Note:[/b] Can exceed 100 pixels with manual input.[br]
## [b]Warning:[/b] If time value falls below  [code]jump_time[/code]  value unexpected behavior may occur.
@export_range(0.0, 100, 1, "or_greater", "suffix:px") var jump_height: float = 0
@export var jump_height_offset: bool = false

var actor: Node
var gravity: float
var initial_velocity: float
var is_jumping: bool = false
var target_position: Vector2
var has_target: bool = false
var horizontal_velocity: float = 0.0

func _ready() -> void:
	actor = get_node_or_null(actor_path)

func calculate_gravity() -> void:
	if jump_height_offset:
		var height_roll: float = randf()
		var modified_jump_height: float = jump_height

		if height_roll <= 0.15:
			modified_jump_height *= 0.5
		elif height_roll >= 0.85:
			modified_jump_height *= 1.5

		gravity = (2.0 * modified_jump_height) / pow(jump_time, 2)
		initial_velocity = -gravity * jump_time
		if enable_debug:
			print(actor.name, "| Jump Height Offset switched on. Jump Height: ", modified_jump_height, "| Initial velocity: ", initial_velocity)
	else:
		gravity = (2.0 * jump_height) / pow(jump_time, 2)
		initial_velocity = -gravity * jump_time
		if enable_debug:
			print(actor.name, "| Jump Height Offset switched off. Jump Height: ", jump_height)

func start_jump() -> void:
	is_jumping = true
	has_target = false
	calculate_gravity()
	actor.velocity.y = initial_velocity
	if enable_debug:
		print(actor.name, " started jump.")

func jump_to(target: Vector2) -> void:
	target_position = target
	has_target = true
	is_jumping = true

	var displacement : Variant = target_position - actor.global_position
	calculate_gravity()
	
	var total_time : float = jump_time * 2.0
	horizontal_velocity = displacement.x / total_time
	actor.velocity = Vector2(horizontal_velocity, initial_velocity)

	if enable_debug:
		print(actor.name, " jumping to ", target_position, " with vx=", horizontal_velocity)

func apply(delta: float) -> void:
	if not is_jumping:
		return
	actor.velocity.y += gravity * delta
