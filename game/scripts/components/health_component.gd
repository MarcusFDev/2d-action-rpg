class_name HealthComponent
extends Component

signal update_health(old_health: float, new_health: float)

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
@export_range(1, 15, 1, "or_greater", "suffix:Hearts") var starting_health: float

@onready var actor: Node = get_node_or_null(actor_path)

# Script Variables
var current_health: float
var is_dead: bool = false

func _ready() -> void:
	current_health = clamp(starting_health, 0.0, max_health)
	if enable_debug:
		print(actor.name, " | HealthComponent | Initialized Health: ", current_health, "/", max_health)

func gain_health(amount: float) -> void:
	if is_dead:
		if enable_debug:
			print(actor.name, " | HealthComponent | Cannot Gain Health. ", actor.name ," is dead.")
		return
	var old_health: float = current_health
	current_health = clamp(current_health + amount, 0.0, max_health)
	if enable_debug:
		print(actor.name, " | HealthComponent | Current Health: ", current_health)
	if old_health != current_health:
		if enable_debug:
			print(actor.name, " | HealthComponent | Detected Health Update. Emitting signal.")
		emit_signal("update_health", old_health, current_health)

func lose_health(amount: float) -> void:
	if is_dead:
		if enable_debug:
			print(actor.name, " | HealthComponent | Cannot Lose Health. ", actor.name, " is dead.")
	var old_health: float = current_health
	current_health -= amount
	if current_health <= 0.0:
		current_health = 0.0
		is_dead = true
		if enable_debug:
			print(actor.name, " | HealthComponent | ", actor.name, " has died.")
	else:
		if enable_debug:
			print(actor.name, " | HealthComponent | ", actor.name, " has taken ", amount, " damage.(", current_health, "/", max_health, ")")
	if old_health != current_health:
		if enable_debug:
			print(actor.name, " | HealthComponent | Detected Health Update. Emitting signal.")
		emit_signal("update_health", old_health, current_health)

func reset_health() -> void:
	current_health = clamp(starting_health, 0.0, max_health)
	is_dead = false
	if enable_debug:
		print(actor.name, " | HealthComponent | Health reset.")
