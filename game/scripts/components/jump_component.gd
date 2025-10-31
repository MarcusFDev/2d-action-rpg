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

var actor: Node
var gravity: float
var initial_velocity: float
var is_jumping: bool = false

func _ready() -> void:
	actor = get_node_or_null(actor_path)
	gravity = (2.0 * jump_height) / pow(jump_time, 2)
	initial_velocity = -gravity * jump_time

func start_jump() -> void:
	is_jumping = true
	actor.velocity.y = initial_velocity
	if enable_debug:
		print(actor.name, " started jump")

func apply(delta: float) -> void:
	if not is_jumping:
		return
	actor.velocity.y += gravity * delta
