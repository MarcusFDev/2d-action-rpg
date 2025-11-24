class_name JumpComponent
extends Component

## Assign the parent entity path to the component.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Component Settings")
## Determines in seconds it takes to reach the  [code]jump_height[/code]  value.[br]
## [b]Note:[/b] Can exceed 3 seconds with manual input.[br]
## [b]Note:[/b] Values  [code]0.4[/code]  and lower automatically use Global gravity value.
@export_range(0.0, 3.0, 0.1, "or_greater", "suffix:s") var jump_time: float = 0
## Determines the height the entity attempts to reach. [br]
## [b]Note:[/b] Can exceed 100 pixels with manual input.[br]
@export_range(0.0, 100, 1, "or_greater", "suffix:px") var jump_height: float = 0
## Offsets the jump height based on the entity's  [code]jump_height[/code] value. [br]
@export var jump_height_offset: bool = false

@export_group("Enable Jump Cooldown", "export_")

@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_jump_cooldown: bool = false
@export_range(0.0, 5.0, 0.1, "suffix:s") var export_jump_cooldown: float = 0

@export_group("Enable Multi-Jump", "export_")

@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_multi_jump: bool = false
@export_range(0, 5, 1, "suffix:Extra Jumps") var export_jump_count: int = 0
@export_range(0.0, 10.0, 0.1, "or_greater", "suffix:s") var export_recharge_time: float = 0

@export_group("Component Paths")
## Assign the  [code]GroundCheckComponent[/code]  path to the component.[br]
## [b]Note:[/b] This is important as some settings require ground contact information to work correctly.
@export var ground_check_path: NodePath
@export var gravity_component_path: NodePath

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)
@onready var gravity_comp: Node = get_node_or_null(gravity_component_path)
@onready var ground_check: Node = get_node_or_null(ground_check_path)

# Script Variables
var jump_gravity: float
var gravity: float

var initial_velocity: float
var jump_force: float
var is_jumping: bool = false

var target_position: Vector2
var horizontal_velocity: float = 0.0

var cooldown_active: bool = false
var cooldown_timer: float = 0.0

var recharge_timer: float = 0.0
var is_recharging: bool = false

var base_jumps: int = 1
var initial_extra_jumps: int:
	get:
		return export_jump_count
var current_extra_jumps: int = 0

func _ready() -> void:
	gravity = gravity_comp.gravity
	reset_jump_counter()

# -------------------------
#  TIMER + COOLDOWN
# -------------------------
func update_timer(delta: float) -> void:
	if cooldown_active and is_grounded():
		cooldown_timer -= delta
		if cooldown_timer <= 0.0:
			cooldown_active = false
			cooldown_timer = 0.0
			if enable_debug:
				print(actor.name, " jump cooldown complete.")
	
	if is_recharging:
		recharge_timer -= delta
		if recharge_timer <= 0.0:
			is_recharging = false
			export_enable_multi_jump = true
			if is_grounded():
				reset_jump_counter()
				if enable_debug:
					print(actor.name, " multi-jump recharged and available again.")
			else:
				if enable_debug:
					print(actor.name, " multi-jump recharge finished but still mid-air. Will reset on landing.")

func start_recharge() -> void:
	if export_recharge_time > 0.0:
		is_recharging = true
		recharge_timer = export_recharge_time
		export_enable_multi_jump = false
		if enable_debug:
				print(actor.name, " started multi-jump recharge (", export_recharge_time, "s)")

func start_cooldown() -> void:
	if export_jump_cooldown > 0.0:
		cooldown_active = true
		cooldown_timer = export_jump_cooldown
		if enable_debug:
			print(actor.name, " jump cooldown started (", export_jump_cooldown, "s)")

# -------------------------
#  JUMP PHYSICS
# -------------------------
func height_offset() -> float:
	var height_roll: float = randf()
	var modified_jump_height: float = jump_height

	if height_roll <= 0.15:
		modified_jump_height *= 0.5

	elif height_roll >= 0.85:
		modified_jump_height *= 1.5
	
	if enable_debug:
		print(actor.name, "| Jump Height Offset switched on. Jump Height: ", modified_jump_height)
	
	return modified_jump_height

func calculate_gravity() -> void:
	if jump_height_offset:
		jump_height = height_offset()

	if jump_time <= 0.4:
		jump_force = -sqrt(2.0 * jump_height * gravity)
		if enable_debug:
			print(actor.name, " | Jump Force: ", jump_force, " | Jump Height: ", jump_height, " | Gravity:", gravity)
	else:
		jump_gravity = (2.0 * jump_height) / pow(jump_time, 2)
		jump_force = -sqrt(2.0 * jump_height * jump_gravity)
		actor.gravity_comp.gravity = jump_gravity
	
		if enable_debug:
			print(actor.name, " | Jump Force: ", jump_force, " | Jump Height: ", jump_height, " | Jump Gravity: ", jump_gravity)

func is_grounded() -> bool:
	if ground_check:
		return ground_check.is_grounded
	return false
# -------------------------
#  JUMP LOGIC
# -------------------------
func perform_jump() -> void:
	if not can_jump():
		if enable_debug:
			print(actor.name, " tried to jump but cooldown active or out of jumps.")
		return
	is_jumping = true
	
	calculate_gravity()
	actor.velocity.y = jump_force
	
	consume_jump()

	if export_enable_jump_cooldown and not current_extra_jumps > 0:
		start_cooldown()

	if enable_debug:
		print(actor.name, " started jump. Base Jumps remaining: ", base_jumps, " Extra Jumps remaining: ", current_extra_jumps)

func perform_target_jump(direction: Variant) -> void:
	if not can_jump():
		if enable_debug:
			print(actor.name, " tried to jump_to but cooldown active or out of jumps.")
		return

	var jump_offset: Vector2

	if typeof(direction) == TYPE_VECTOR2:
		jump_offset = direction.normalized() * 24.0
	elif typeof(direction) == TYPE_INT or typeof(direction) == TYPE_FLOAT:
		jump_offset = Vector2(24.0 * float(direction), 0.0)

	target_position = actor.global_position + jump_offset + Vector2(0.0, -32.0)

	is_jumping = true

	var displacement: Vector2 = target_position - actor.global_position
	calculate_gravity()

	var total_time: float = jump_time * 2.0
	horizontal_velocity = displacement.x / total_time
	actor.velocity = Vector2(horizontal_velocity, initial_velocity)

	if enable_debug:
		print(
			actor.name, 
			" jumping to ", target_position, 
			" | vx=", horizontal_velocity, 
			" | direction type=", typeof(direction)
		)


# -------------------------
#  MULTI-JUMP SYSTEM
# -------------------------
func can_jump() -> bool:
	if cooldown_active:
		return false
	
	if base_jumps <= 0 and current_extra_jumps <=0:
		return false
	
	return true

func consume_jump() -> void:
	if current_extra_jumps > 0:
		current_extra_jumps -= 1
		if current_extra_jumps == 0 and export_enable_multi_jump and export_recharge_time > 0:
			start_recharge()
	elif base_jumps > 0:
		base_jumps -= 1
  
func reset_jump_counter() -> void:
	if is_recharging and export_enable_multi_jump:
		return
	base_jumps = 1
	if export_enable_multi_jump:
		if is_grounded():
			current_extra_jumps = export_jump_count
		else:
			current_extra_jumps = 0
	else:
		current_extra_jumps = 0
	if enable_debug:
		print(actor.name, " jump counter reset -> Base Jumps: ", base_jumps, " Extra Jumps: ", current_extra_jumps)
