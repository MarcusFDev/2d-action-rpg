class_name MovementComponent
extends Component

## Assign the parent entity to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
## Determines entity movement speed. [br]
## [b]Note:[/b] Can exceed 200 with manual input.
@export_range(0, 200, 1, "suffix:px/s", "or_greater") var move_speed: float = 0

@export_group("Direction Options")
enum EntityType { GROUND, FLYING, BOTH }
@export var entity_type: EntityType

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)

# Script Variables
var direction: Variant
var _timers : Dictionary = {}

func process_physics() -> void:
	actor.velocity = direction * move_speed
	if enable_debug:
		print(
			"MovementComponent: ", actor.name,
			" | Direction: ", direction,
			" | Speed: ", move_speed,
			" | Velocity X before move: ", actor.velocity.x)

func direction_randomizer(id: String, chance: float, interval: float, delta: float) -> Variant:
	if interval <= 0:
		if enable_debug:
			print(actor.name, " MovementComponent: DirectionRandomizer entered but interval value 0.")
		return {"success": false, "direction": direction}
	
	if not _timers.has(id):
		_timers[id] = 0.0
	
	_timers[id] += delta
	if _timers[id] >= interval:
		_timers[id] = 0.0
		var roll: float = randf() * 100.0
		var success: bool = roll < chance
		if success: 
			match entity_type:
				EntityType.GROUND:
					direction.x *= -1.0
				EntityType.FLYING:
					direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
				EntityType.BOTH:
					if randi() % 2 == 0:
						direction.x *= -1.0
					else:
						direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
				
			if enable_debug:
				print(actor.name, " | MovementComponent: DirectionRandomizer: Id:", id, " | Roll Value:", roll, " | Chance: ", chance," | Direction:", direction, " | Success: ", success)	
				
			return {"success": true, "direction": direction}
	
	return {"success": false, "direction": direction}

func set_direction(new_direction: Variant) -> void:
	if typeof(new_direction) == TYPE_INT or typeof(new_direction) == TYPE_FLOAT:
		direction = Vector2(new_direction, 0).normalized()
	elif typeof(new_direction) == TYPE_VECTOR2:
		direction = new_direction.normalized()

func get_direction() -> Variant:
	return direction

#func apply_physics(_delta: float) -> void:
	#actor.velocity = direction * move_speed
	#if enable_debug:
		#print(
			#"MovementComponent: ", actor.name,
			#" | Direction: ", direction,
			#" | Speed: ", move_speed,
			#" | Velocity X before move: ", actor.velocity.x)
