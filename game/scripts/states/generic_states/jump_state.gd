class_name JumpState
extends State

@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("State Settings")
## Determines the animation that plays during the Jump State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var state_animation: String
@export var use_parent_logic: bool = false

@export_group("Use Behavior Tree", "export_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_use_behavior_tree: bool = false
@export var export_enable_randomize_direction: bool = false

@export_group("Component Paths")

@export var gravity_component: NodePath
@export var ground_check_component: NodePath
@export var jump_component: NodePath
@export var movement_component: NodePath

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)
@onready var ground_check_comp: Node = get_node_or_null(ground_check_component)
@onready var jump_comp: Node = get_node_or_null(jump_component)
@onready var gravity_comp: Node = get_node_or_null(gravity_component)
@onready var movement_comp: Node = get_node_or_null(movement_component)

# Callback Functions
func _on_enter() -> void: pass
func _on_input(_event: InputEvent) -> void: pass
func _on_physics(_delta: float) -> void: pass
func _on_frame(_delta: float) -> void: pass

# Callback Variables
var enter_callback: Callable = _on_enter
var handle_input: Callable = _on_input
var handle_physics: Callable = _on_physics
var handle_frame: Callable = _on_frame

# Script Variables
var direction: int = 0
var jumps_remaining: int = 0
var jump_timer: float = 0.0
var jump_cooldown: bool = false

# --------------------------------------------------------------------
# STATE ENTER
# --------------------------------------------------------------------
func enter() -> void:
	super.enter()
	if enable_debug:
		print(
		"===========================\n",
		"JumpState entered by: ", actor.name, "\n",
		"===========================")
	init_jump()

func init_jump() -> void:
	actor.animations.play(state_animation)
	
	if use_parent_logic:
		jump_comp.perform_jump()
	
	if export_use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		bb["locked"] = true
		bb["force_jump"] = false
		bb["is_jumping"] = true
		bb["can_jump"] = false
		bb["has_collided"] = false
		direction = bb["move_direction"]

		if export_enable_randomize_direction:
			bb["direction"] = movement_comp.randomize_direction()
		else:
			direction = bb["move_direction"]
		
		jumps_remaining = jump_comp.base_jumps + jump_comp.initial_extra_jumps

		if enable_debug:
			print(
				actor.name,
				" | JumpState: Combining Base Jumps: ", jump_comp.base_jumps,
				" & Extra Jumps: ", jump_comp.initial_extra_jumps,
				" to: ", jumps_remaining, " jumps.")

# --------------------------------------------------------------------
# STATE PHYSICS
# --------------------------------------------------------------------
func process_physics(delta: float) -> State:
	actor.move_and_slide()
	jump_comp.apply_physics(delta)

	if export_use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		var grounded: bool = bb["is_grounded"]
		
		if grounded:
			if not jump_comp.cooldown_active and jumps_remaining > 0:
				jump_comp.perform_target_jump(direction)
				jump_comp.start_cooldown()
				
				jumps_remaining -= 1
				
			elif jump_comp.cooldown_active:
				actor.velocity.x = 0
				pass
			
			else:
				jump_comp.reset_jump_counter()
				bb["can_jump"] = true
				bb["is_jumping"] = false
				bb["locked"] = false
				bb["can_patrol"] = true

				if enable_debug:
					print(actor.name, " | JumpState finished all jumps.")

	if use_parent_logic:
		return handle_physics.call(delta)
	return null

func process_input(event: InputEvent) -> State:
	if use_parent_logic:
		return handle_input.call(event)
	return null

func process_frame(delta: float) -> State:
	if use_parent_logic:
		return handle_frame.call(delta)
	return null

func exit() -> void:
	if enable_debug:
		print(actor.name, " | JumpState exited.")
