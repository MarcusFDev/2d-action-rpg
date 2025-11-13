class_name GravityComponent
extends Component

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
## Determines the strength of the gravitational pull applied to the entity. [br]
## [b]Note:[/b] Higher values increase downward acceleration; lower values create a lighter, floatier feel (e.g. Moon gravity). [br]
## [b]Tip:[/b] Can exceed 2000 px/s² with manual input.
@export_range(0, 2000, 100, "suffix:px²", "or_greater") var gravity: float = 1200.0

# Script Variables
@onready var actor: Node = get_node_or_null(actor_path)

func apply(delta: float) -> void:
	var is_grounded : bool = false

	if actor.has_method("is_on_floor"):
		is_grounded = actor.is_on_floor()
	
	if not is_grounded:
		actor.velocity.y += gravity * delta
