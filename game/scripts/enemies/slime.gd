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

var patrol_direction: int = 1

var blackboard: Dictionary = {
	"fsm": null,
	"is_grounded": false,
	"can_patrol": true,
	"can_idle": true,
	"intent": "Idle"
}

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
	blackboard["can_patrol"] = true
	blackboard["can_idle"] = true
	blackboard["intent"] = "Idle"

func _setup_states() -> void:
	_idle_state()
	_patrol_state()
	_jump_state()
	_fall_state()

func _idle_state() -> void:
	idle_state.enter_callback = func() -> void:
		idle_state.set_direction()

func _patrol_state() -> void:
	patrol_state.enter_callback = func() -> void:
		animations.flip_h = patrol_state.direction < 0

func _jump_state() -> void:
	jump_state.enter_callback = func() -> void:
		pass

func _fall_state() -> void:
	pass

func _setup_behavior_tree() -> void:
	bt_root = BTSelector.new([
		# Priority 1: Fall if not grounded
		BTSequence.new([
			BTCondition.new("is_grounded", false),
			BTAction.new("Fall")
		]),
		# Priority 2: Patrol if grounded and allowed
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("can_patrol", true),
			BTAction.new("Patrol")
		]),
		# Priority 3: Idle if grounded and allowed
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("can_idle", true),
			BTAction.new("Idle")
		])
	])
	bt = BehaviorTree.new(bt_root, blackboard, self)

func _process(delta: float) -> void:
	if bt:
		bt.tick()
	state_machine.process_frame(delta)
	if enable_debug:
		print(
		"Intent:", blackboard["intent"],
		" | Grounded:", blackboard["is_grounded"],
		" | State:", state_machine.current_state.name
	)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()
	ground_check_component.apply(delta)

func trigger_attack() -> void:
	if attack_state:
		state_machine.change_state(attack_state)
