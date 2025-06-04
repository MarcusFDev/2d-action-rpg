extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $Animations
@onready var state_machine: Node = $StateMachine
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

@export var damage: int = 1


func _ready() -> void:
	state_machine.init(self, animations)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()

func trigger_attack() -> void:
	if state_machine.current_state.name != "slime_attack":

		var attack_state: State = state_machine.get_state("slime_attack")
		if attack_state:
			state_machine.change_state(attack_state)
