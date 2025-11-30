class_name PickUpPermissionComponent
extends Component

signal pickup_received(data: Dictionary)

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
## Attach the actor specific pickup_permission Resource.
@export var permissions: PickUpPermissionResource

@onready var actor: Node = get_node_or_null(actor_path)

func _ready() -> void:
	if permissions:
		permissions.rebuild_allowed()

func apply_pickup(data: Dictionary) -> void:
	if permissions == null:
		if enable_debug:
			print(actor.name, " | PickUpPermissionComponent: No Permissions found.")
		return

	var item_id: String = data.get("item_id")
	
	if item_id in permissions.allowed:
		if enable_debug:
			print(actor.name, " | PickUpPermissionComponent: Permissions found & granted.")
		pickup_received.emit(data)
