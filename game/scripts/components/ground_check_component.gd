class_name GroundCheckComponent
extends Node

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Determines how long the entity must remain on the ground before being considered "grounded." [br]
## [b]Note:[/b] Helps prevent false ground detections when briefly touching surfaces or slopes. [br]
## [b]Tip:[/b] Can exceed 3 seconds with manual input.
@export_range(0, 3, 0.1, "suffix:s", "or_greater") var grounded_buffer: float = 0
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

# Script Variables
var actor: Node
var grounded_timer: float = 0.0
var is_grounded: bool = false

func _ready() -> void:
	actor = get_node_or_null(actor_path)

func apply(delta: float) -> void:
	var on_floor : bool = actor.is_on_floor()

	if on_floor:
		grounded_timer += delta
		if grounded_timer >= grounded_buffer and not is_grounded:
			is_grounded = true
			grounded_timer = grounded_buffer 
			if enable_debug:
				print(actor.name, " confirmed grounded.")
	else:
		is_grounded = false
		grounded_timer = 0.0
		if enable_debug:
			print(actor.name, " lost ground contact.")
