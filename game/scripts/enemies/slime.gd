extends CharacterBody2D

@export var actor_path: NodePath
@export var animations_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Actor Settings")

@export_group("Temporary Options")
@export var damage: int = 1

@export_group("State Paths")
@export var state_machine_path: NodePath
@export var idle_state_path: NodePath
@export var patrol_state_path: NodePath
@export var jump_state_path: NodePath
@export var fall_state_path: NodePath
@export var attack_state_path: NodePath

@export_group("Component Paths")
@export var ground_check_component: NodePath
@export var direction_flip_component: NodePath
@export var edge_detector_component: NodePath
@export var jump_component: NodePath

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)
@onready var animations: AnimatedSprite2D = get_node_or_null(animations_path)
@onready var state_machine: Node = get_node_or_null(state_machine_path)
@onready var idle_state: Node = get_node_or_null(idle_state_path)
@onready var patrol_state: Node = get_node_or_null(patrol_state_path)
@onready var jump_state: Node = get_node_or_null(jump_state_path)
@onready var fall_state: Node = get_node_or_null(fall_state_path)
@onready var attack_state: Node = get_node_or_null(attack_state_path)
	
@onready var ground_check_comp: Node = get_node_or_null(ground_check_component)
@onready var direction_flip_comp: Node = get_node_or_null(direction_flip_component)
@onready var edge_detector_comp: Node = get_node_or_null(edge_detector_component)
@onready var jump_comp: Node = get_node_or_null(jump_component)

# Internal BehaviorTree Variables
var _prev_state_name: String = ""
var bt_root: BTNode
var bt: BehaviorTree
var blackboard: Dictionary = {}

# Script Variables
var jump_cooldown_timer: float = 0.0

func _ready() -> void:
	_setup_states()
	_setup_blackboard()
	state_machine.init(self, animations, blackboard)
	_setup_behavior_tree()
	jump_cooldown_timer = 0.0

func get_blackboard() -> Dictionary:
	return blackboard

func _setup_blackboard() -> void:
	blackboard["fsm"] = state_machine
	
	blackboard["is_grounded"] = false
	blackboard["has_collided"] = false
	blackboard["force_idle"] = false
	blackboard["is_jumping"] = false
	
	blackboard["can_patrol"] = true
	blackboard["can_idle"] = true
	blackboard["can_jump"] = true
	
	blackboard["move_direction"] = 1
	blackboard["intent"] = "Idle"

func _setup_behavior_tree() -> void:
	bt_root = BTSelector.new([
		# Priority 1: Fall if not grounded
		BTSequence.new([
			BTCondition.new("is_grounded", false),
			BTAction.new("Fall")
		]),
		# Priority 2: Idle if grounded and forced
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("force_idle", true),
			BTAction.new("Idle")
		]),
		# Priority 3: Patrol if grounded and allowed
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("has_collided", false),
			BTCondition.new("can_patrol", true),
			BTAction.new("Patrol")
		]),
		# Priority 4: Idle if grounded
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("has_collided", true),
			BTSelector.new([
				BTSequence.new([
					BTCondition.new("can_jump", true),
					BTCondition.new("is_jumping", false),
					BTCondition.new("jump_cooldown", false),
					BTCondition.new("random_chance", 0.01),
					BTAction.new("Jump"),
				]),
				BTSequence.new([
					BTCondition.new("can_idle", true),
					BTAction.new("Idle")
				])
			])
		]),
		BTAction.new("Idle")
	])
	bt = BehaviorTree.new(bt_root, blackboard, self)

func _setup_states() -> void:
	_idle_state()
	_patrol_state()
	_jump_state()
	_fall_state()

func _idle_state() -> void:
	idle_state.enter_callback = func() -> void:
		pass

func _patrol_state() -> void:
	patrol_state.enter_callback = func() -> void:
		animations.flip_h = patrol_state.direction < 0

func _jump_state() -> void:
	jump_state.enter_callback = func() -> void:
		pass

func _fall_state() -> void:
	pass

func _process(delta: float) -> void:
	if bt:
		bt.tick()
	state_machine.process_frame(delta)
	
	if enable_debug:
		var current_state_name : Variant = state_machine.current_state.name
		if current_state_name != _prev_state_name:
			_prev_state_name = current_state_name
			print("==============================")
			print("[STATE CHANGE] →", current_state_name)
			for key: Variant in blackboard.keys():
				print(" ", key, ":", blackboard[key])
			print("==============================")

func _physics_process(delta: float) -> void:
	move_and_slide()
	ground_check_comp.apply(delta)

	var grounded : bool = ground_check_comp.is_grounded
	blackboard["is_grounded"] = grounded
	blackboard["jump_cooldown"] = jump_cooldown_timer > 0.0
	
	# --- Jump cooldown tracking ---
	if jump_cooldown_timer > 0.0:
		jump_cooldown_timer -= delta
		if jump_cooldown_timer <= 0.0:
			jump_cooldown_timer = 0.0
			blackboard["jump_cooldown"] = false
	else:
		blackboard["jump_cooldown"] = false
	# ------------------------------

	direction_flip_comp.apply(delta)
	jump_comp.update_timer(delta)
	state_machine.process_physics(delta)
	ground_check_comp.post_update()

func trigger_attack() -> void:
	if attack_state:
		state_machine.change_state(attack_state)
