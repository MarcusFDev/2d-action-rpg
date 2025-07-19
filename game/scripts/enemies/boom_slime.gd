extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $Animations
@onready var state_machine: Node = $EnemyAI/StateMachine
@onready var idle_state: IdleState = $EnemyAI/StateMachine/IdleState
@onready var patrol_state: MoveState = $EnemyAI/StateMachine/PatrolState
@onready var jump_state: JumpState = $EnemyAI/StateMachine/JumpState
@onready var fall_state: FallState = $EnemyAI/StateMachine/FallState
@onready var bb: Node = $EnemyAI/BlackBoard

var patrol_direction: int = 1

func _ready() -> void:
	_setup_states()
	_setup_blackboard()
	state_machine.init(self, animations)

func _setup_blackboard() -> void:
	bb.set_value("fsm", state_machine)
	bb.set_value("is_grounded", false)
	bb.set_value("can_patrol", true)
	bb.set_value("can_idle", true)

func _setup_states() -> void:
	_idle_state()
	_patrol_state()
	_jump_state()
	_fall_state()

func _idle_state() -> void:
	pass

func _patrol_state() -> void:
	pass

func _jump_state() -> void:
	pass

func _fall_state() -> void:
	pass

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()
