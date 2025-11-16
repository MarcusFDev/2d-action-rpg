extends CharacterBody2D

@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Actor Settings")
@export var animations_path: NodePath

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
@export var animation_component: NodePath
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
@onready var animation_comp: Node = get_node_or_null(animation_component)
@onready var edge_detector_comp: Node = get_node_or_null(edge_detector_component)
@onready var jump_comp: Node = get_node_or_null(jump_component)

# Internal BehaviorTree Variables
var _prev_state_name: String = ""
var bt_root: BTNode
var bt: BehaviorTree
var blackboard: Dictionary = {}

func _ready() -> void:
	_setup_states()
	_setup_blackboard()
	_setup_behavior_tree()
	state_machine.init(self, animations, blackboard)

func get_blackboard() -> Dictionary:
	return blackboard

func _setup_blackboard() -> void:
	blackboard["fsm"] = state_machine
	
	blackboard["is_grounded"] = true
	blackboard["has_collided"] = false
	
	blackboard["force_idle"] = false
	blackboard["force_jump"] = false
	blackboard["force_patrol"] = false
	
	blackboard["can_patrol"] = true
	blackboard["can_idle"] = true
	blackboard["can_jump"] = true
	
	blackboard["locked"] = false
	blackboard["move_direction"] = 1
	blackboard["intent"] = "Fall" # Note: Must Match StateMachine Starting State

func _setup_behavior_tree() -> void:
	bt_root = BTSelector.new([
		# Priority 1
		BTSequence.new([
			BTCondition.new("is_grounded", false),
			BTCondition.new("locked", false),
			BTAction.new("Fall")
		]),
		# Priority 2
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("force_idle", true),
			BTCondition.new("locked", false),
			BTAction.new("Idle")
		]),
		# Priority 3
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("force_jump", true),
			BTCondition.new("locked", false),
			BTAction.new("Jump")
		]),
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("force_patrol", true),
			BTCondition.new("locked", false),
			BTAction.new("Patrol")
		]),
		# Priority 4
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("has_collided", false),
			BTCondition.new("can_patrol", true),
			BTCondition.new("locked", false),
			BTAction.new("Patrol")
		]),
		# Priority 5
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("has_collided", true),
			BTCondition.new("locked", false),
			BTSelector.new([
				BTSequence.new([
					BTCondition.new("can_jump", true),
					BTCondition.new("random_chance", 0.50),
					BTCondition.new("locked", false),
					BTAction.new("Jump"),
				]),
				BTSequence.new([
					BTCondition.new("can_idle", true),
					BTCondition.new("locked", false),
					BTAction.new("Idle")
				])
			])
		]),
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
		pass

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
	
	animation_comp.animation_flip(delta)
	jump_comp.update_timer(delta)
	state_machine.process_physics(delta)
	ground_check_comp.post_update()

func trigger_attack() -> void:
	if attack_state:
		state_machine.change_state(attack_state)
