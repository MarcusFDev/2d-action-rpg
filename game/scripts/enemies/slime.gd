extends CharacterBody2D


@export var damage: int = 1
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@onready var animations: AnimatedSprite2D = $Animations
@onready var state_machine: Node = $StateMachine
@onready var idle_state: IdleState = $StateMachine/IdleState
@onready var patrol_state: MoveState = $StateMachine/PatrolState
@onready var jump_state: JumpState = $StateMachine/JumpState
@onready var fall_state: FallState = $StateMachine/FallState
@onready var attack_state: AttackState = $StateMachine/AttackState

# Components
@onready var ground_check_component: Node = $Components/GroundCheckComponent
@onready var direction_flip_component: Node = $Components/DirectionFlipComponent
@onready var edge_detector_component: Node = $Components/EdgeDetectorComponent
@onready var jump_component: Node = $Components/JumpComponent

var blackboard: Dictionary = {
	"fsm": null,
	"is_grounded": false,
	"can_patrol": true,
	"can_idle": true,
	"intent": "Idle"
}

var _prev_state_name: String = ""
var bt_root: BTNode
var bt: BehaviorTree

func _ready() -> void:
	_setup_states()
	_setup_blackboard()
	state_machine.init(self, animations, blackboard)
	_setup_behavior_tree()

func get_blackboard() -> Dictionary:
	return blackboard

func _setup_blackboard() -> void:
	blackboard["fsm"] = state_machine
	
	blackboard["is_grounded"] = false
	blackboard["has_collided"] = false
	blackboard["force_idle"] = false
	
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
					BTCondition.new("random_chance", 0.01),
					BTAction.new("Jump"),
				]),
				BTSequence.new([
					BTCondition.new("can_idle", true),
					BTAction.new("Idle")
				])
			])
		])
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
	state_machine.process_physics(delta)
	move_and_slide()
	ground_check_component.apply(delta)
	var grounded: bool = ground_check_component.is_grounded
	blackboard["is_grounded"] = grounded
	direction_flip_component.apply(delta)
	jump_component.update_timer(delta)
	blackboard["can_jump"] = jump_component.is_active

func trigger_attack() -> void:
	if attack_state:
		state_machine.change_state(attack_state)
