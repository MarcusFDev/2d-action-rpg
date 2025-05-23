class_name PlayerIdleState
extends State

@export var fall: State
@export var jump: State
@export var move: State
@export var jump_force: float = -300

func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		parent.velocity.y = jump_force
		#print("jump triggered from idle.gd")
		return jump
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		#print("move triggered from idle.gd")
		return move
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		#print("fall triggered from idle.gd")
		return fall
	return null
