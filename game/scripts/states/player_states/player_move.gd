class_name PlayerMoveState
extends State
#
#@export var jump: State
#@export var fall: State
#@export var idle: State
#@export var jump_force: float = -300
#
#func process_physics(delta: float) -> State:
	#parent.velocity.y += gravity * delta
	#
	#var input_direction: float = Input.get_axis("move_left", "move_right")
	#var movement: float = input_direction * move_speed
	#
	#if movement == 0:
		##print("Idle triggered from move.gd")
		#return idle
	#
	#parent.animations.flip_h = movement < 0
	#parent.velocity.x = movement
	#
	#if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		#parent.velocity.y = jump_force
		##print("Jump triggered from move.gd")
		#return jump
	#
	#parent.move_and_slide()
	#
	#if not parent.is_on_floor():
		##print("fall triggered from move.gd")
		#return fall
	#
	#return null
