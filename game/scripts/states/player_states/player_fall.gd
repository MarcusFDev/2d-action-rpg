class_name PlayerFallState
extends State

#@export var move: State
#@export var idle: State
#
#var move_speed: float = 120
#
#func process_physics(delta: float) -> State:
	#parent.velocity.y += gravity * delta
	#
	#var movement: float = Input.get_axis("move_left", "move_right") * move_speed
	#if movement != 0:
		#parent.animations.flip_h = movement < 0
	#parent.velocity.x = movement
	#
	#parent.move_and_slide()
	#
	#if parent.is_on_floor():
		#if movement != 0:
			##print("move triggered from fall.gd")
			#return move
		##print("idle triggered from fall.gd")
		#return idle
	#return null
