extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $Animations
@onready var state_machine: Node = $StateMachine
@onready var idle_state: IdleState = $StateMachine/IdleState
@onready var patrol_state: MoveState = $StateMachine/PatrolState
@onready var jump_state: JumpState = $StateMachine/JumpState
@onready var fall_state: FallState = $StateMachine/FallState

@export var damage: int = 1

var patrol_direction: int = 1

func _ready() -> void:
	_setup_states()
	state_machine.init(self, animations)
	call_deferred("_post_ready_check")

func _post_ready_check() -> void:
	if not is_on_floor():
		state_machine.change_state(fall_state)

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

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()

func trigger_attack() -> void:
	if state_machine.current_state.name != "SlimeAttack":

		var attack_state: State = state_machine.get_state("SlimeAttack")
		if attack_state:
			state_machine.change_state(attack_state)
