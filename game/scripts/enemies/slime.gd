extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $Animations
@onready var state_machine: Node = $StateMachine
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var idle_state: IdleState = $StateMachine/IdleState
@onready var patrol_state: MoveState = $StateMachine/PatrolState
@onready var fall_state: State = $StateMachine/SlimeFall

@export var damage: int = 1

var patrol_direction: int = 1

func _ready() -> void:
	_setup_states()
	state_machine.init(self, animations)
	call_deferred("_post_ready_check")

func _post_ready_check():
	if not is_on_floor():
		state_machine.change_state(fall_state)

func _setup_states():
	_idle_state()
	_patrol_state()

func _idle_state():
	idle_state.enter_callback = func():
		idle_state.set_direction()
		animations.play("slime_idle")

func _patrol_state():
	patrol_state.enter_callback = func():
		animations.flip_h = patrol_state.direction < 0


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
