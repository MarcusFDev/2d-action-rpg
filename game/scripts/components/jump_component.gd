class_name JumpComponent
extends Node

## Assign the parent entity path to the component.
@export var actor_path: NodePath
## Assign the  [code]GroundCheckComponent[/code]  path to the component.[br]
## [b]Note:[/b] This is important as some settings require ground contact information to work correctly.
@export var ground_check_path: NodePath
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
@export var jump_height_offset: bool = false

@export_group("Enable Jump Cooldown", "export_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_jump_cooldown: bool = false
@export_range(0.0, 5.0, 0.1, "suffix:s") var export_jump_cooldown: float = 0

@export_group("Enable Multi-Jump", "export_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_multi_jump: bool = false
@export_range(0, 5, 1, "suffix:Extra Jumps") var export_jump_count: int = 0
@export_range(0.0, 10.0, 0.1, "or_greater", "suffix:s") var export_recharge_time: float = 0

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)
@onready var ground_check: Node = get_node_or_null(ground_check_path)

# Script Variables
var gravity: float
var initial_velocity: float
var is_jumping: bool = false
var target_position: Vector2
var has_target: bool = false
var horizontal_velocity: float = 0.0
var is_active: bool = true
var cooldown_timer: float = 0.0
var recharge_timer: float = 0.0
var is_recharging: bool = false
var base_jumps: int = 1
var extra_jumps: int = export_jump_count

func _ready() -> void:
	reset_jump_counter()

func is_grounded() -> bool:
	if ground_check:
		return ground_check.is_grounded
	return false

# -------------------------
#  TIMER + COOLDOWN
# -------------------------
func update_timer(delta: float) -> void:
	if not is_active:
		if is_grounded():
			cooldown_timer -= delta
			if cooldown_timer <= 0.0:
				is_active = true
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
	if export_recharge_time > 0:
		is_recharging = true
		recharge_timer = export_recharge_time
		export_enable_multi_jump = false
		if enable_debug:
				print(actor.name, " started multi-jump recharge (", export_recharge_time, "s)")

func start_cooldown() -> void:
	is_active = false
	cooldown_timer = export_jump_cooldown
	if enable_debug:
		print(actor.name, " jump cooldown started (", export_jump_cooldown, "s)")

# -------------------------
#  JUMP PHYSICS
# -------------------------
func calculate_gravity() -> void:
	if jump_height_offset:
		var height_roll: float = randf()
		var modified_jump_height: float = jump_height

		if height_roll <= 0.15:
			modified_jump_height *= 0.5
		elif height_roll >= 0.85:
			modified_jump_height *= 1.5

		gravity = (2.0 * modified_jump_height) / pow(jump_time, 2)
		initial_velocity = -gravity * jump_time
		if enable_debug:
			print(actor.name, "| Jump Height Offset switched on. Jump Height: ", modified_jump_height, "| Initial velocity: ", initial_velocity)
	else:
		gravity = (2.0 * jump_height) / pow(jump_time, 2)
		initial_velocity = -gravity * jump_time
		if enable_debug:
			print(actor.name, "| Jump Height Offset switched off. Jump Height: ", jump_height)

# -------------------------
#  JUMP LOGIC
# -------------------------
func start_jump() -> void:
	if not can_jump():
		if enable_debug:
			print(actor.name, " tried to jump but cooldown active or out of jumps.")
		return
	is_jumping = true
	has_target = false
	calculate_gravity()
	actor.velocity.y = initial_velocity
	
	var was_extra_jump: int = extra_jumps > 0
	consume_jump()

	if export_enable_jump_cooldown and not was_extra_jump:
		start_cooldown()

	if enable_debug:
		print(actor.name, " started jump. Base Jumps remaining: ", base_jumps, " Extra Jumps remaining: ", extra_jumps)

func jump_to(target: Vector2) -> void:
	if not can_jump():
		if enable_debug:
			print(actor.name, " tried to jump_to but cooldown active or out of jumps.")
		return
	target_position = target
	has_target = true
	is_jumping = true

	var displacement : Variant = target_position - actor.global_position
	calculate_gravity()
	
	var total_time : float = jump_time * 2.0
	horizontal_velocity = displacement.x / total_time
	actor.velocity = Vector2(horizontal_velocity, initial_velocity)
	
	var was_extra_jump: int = extra_jumps > 0
	
	if export_enable_jump_cooldown and not was_extra_jump:
		consume_jump()
	if export_enable_jump_cooldown:
		start_cooldown()

	if enable_debug:
		print(actor.name, " jumping to ", target_position, " with vx=", horizontal_velocity)

func apply(delta: float) -> void:
	if not is_jumping:
		return
	actor.velocity.y += gravity * delta

# -------------------------
#  MULTI-JUMP SYSTEM
# -------------------------
func can_jump() -> bool:
	if not is_active:
		return false
	return base_jumps > 0 or extra_jumps > 0

func consume_jump() -> void:
	if extra_jumps > 0:
		extra_jumps -= 1
		if extra_jumps == 0 and export_enable_multi_jump and export_recharge_time > 0:
			start_recharge()
	elif base_jumps > 0:
		base_jumps -= 1

func reset_jump_counter() -> void:
	if is_recharging and export_enable_multi_jump:
		return
	base_jumps = 1
	if export_enable_multi_jump:
		if is_grounded():
			extra_jumps = export_jump_count
		else:
			extra_jumps = 0
	else:
		extra_jumps = 0
	if enable_debug:
		print(actor.name, " jump counter reset -> Base Jumps: ", base_jumps, " Extra Jumps: ", extra_jumps)
