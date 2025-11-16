class_name PickUpReceiverComponent
extends Component

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
## Determines whether this entity is allowed to receive healing pickups. [br]
## [b]Tip:[/b] Disable this for actors that should ignore health-restoring items.
@export var can_receive_healing: bool = false

@export_group("Component Paths")
@export var health_component: NodePath

# Script Variables
@onready var actor: Node = get_node_or_null(actor_path)
@onready var health_comp: Node = get_node_or_null(health_component)

func apply_pickup(data: Dictionary) -> void:
	if not data.has("type"):
		if enable_debug:
			print(actor.name, " PickUpReceiverComponent: Data does not contain 'type'.")
		return
	
	match data["type"]:
		"heal":
			if can_receive_healing:
				if health_comp:
					health_comp.gain_health(data["amount"])
