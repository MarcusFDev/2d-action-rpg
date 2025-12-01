class_name HealthComponent
extends Component

signal update_health(old_health: float, new_health: float)
signal actor_died

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
## Determines the maximum amount of health this entity can have. [br]
## [b]Note:[/b] Can exceed 15 hearts with manual input.
@export_range(1, 15, 1, "or_greater", "suffix:Hearts") var max_health: float
## Determines the starting health value assigned when the entity spawns or resets. [br]
## [b]Note:[/b] Cannot exceed the maximum health and can be set above 15 with manual input.
@export_range(1, 15, 1, "or_greater", "suffix:Hearts") var base_health: float

@onready var actor: Node = get_node_or_null(actor_path)

# Script Variables
var current_health: float

func _ready() -> void:
	current_health = clamp(base_health, 0.0, max_health)
	if enable_debug:
		print(actor.name, " | HealthComponent | Initialized Health: ", current_health, "/", max_health)

func gain_health(amount: float) -> void:
	var old_health: float = current_health
	current_health = clamp(current_health + amount, 0.0, max_health)
	
	health_update(old_health, current_health)
	
	if enable_debug:
		print(actor.name, " | HealthComponent | Health Gained: ", amount)

func lose_health(amount: float) -> void:
	var old_health: float = current_health
	current_health = clamp(current_health - amount, 0.0, max_health)
	
	health_update(old_health, current_health)
	
	if enable_debug:
		print(actor.name, " | HealthComponent | Health Lost: ", amount)
	
	if current_health <= 0.0:
		actor_died.emit()
		if enable_debug:
			print(actor.name, " | HealthComponent | ", actor.name, " has no health remaining.")
	else:
		if enable_debug:
			print(actor.name, " | HealthComponent | ", actor.name, " has taken ", amount, " damage.(", current_health, "/", max_health, ")")

func health_update(old_hp: float, new_hp: float) -> void:
	if old_hp != new_hp:
		update_health.emit(old_hp, new_hp)
		if enable_debug:
			print(actor.name, " | HealthComponent | Detected Health Update. Emitting signal.")

func reset_health() -> void:
	current_health = clamp(base_health, 0.0, max_health)
	if enable_debug:
		print(actor.name, " | HealthComponent | Health reset.")
