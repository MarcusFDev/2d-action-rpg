extends CharacterBody2D

@onready var animations = $animations
@onready var state_machine = $state_machine
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

@export var damage: int = 10


func _ready() -> void:
	state_machine.init(self, animations)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()
