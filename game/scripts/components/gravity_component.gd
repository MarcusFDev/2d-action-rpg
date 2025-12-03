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
@export_range(0, 2000, 100, "suffix:px²", "or_greater") var gravity: float = 1000.0

@onready var actor: Node = get_node_or_null(actor_path)

# Script Variables
var export_gravity: float

func _ready() -> void:
	export_gravity = gravity

func process_physics(delta: float) -> void:
	gravity = export_gravity
	actor.velocity.y += gravity * delta
	if enable_debug:
		print(actor.name, " | GravityComponent: Gravity applied.")
