class_name PlayerJumpState
extends State

#@export var fall: State
#@export var idle: State
#@export var move: State
#@export var jump_force: float = -300
#@export var jump_duration: float = 1.0

#var move_speed: float = 120.0
#var jump_timer: float = 0.0
#var has_applied_jump : bool = false

#func enter() -> void:
	#jump_timer = 0.0
	#has_applied_jump = false
	#super()

#func process_physics(delta: float) -> State:
	#if not has_applied_jump:
		#parent.velocity.y = jump_force
		#has_applied_jump = true

	#jump_timer += delta
	#parent.velocity.y += gravity * delta

	#var movement: float = Input.get_axis('move_left', 'move_right') * move_speed
	#if movement != 0:
		#parent.animations.flip_h = movement < 0
	#parent.velocity.x = movement
	#parent.move_and_slide()

	#if parent.is_on_floor():
		#if movement != 0:
			#return move
		#return idle

	#if jump_timer >= jump_duration and parent.velocity.y > 0:
		#return fall

	#return null
