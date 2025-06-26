class_name SlimePatrolState
extends State
#
#var direction : int = 1
#@export var speed : float = 60.0
#@export var slime_idle: IdleState
#@export var slime_fall: SlimeFallState
#
#var ray_cast_right: RayCast2D
#var ray_cast_left: RayCast2D
#
#var delay_timer : float = 0.15
#var idle_chance_timer : float = 0.0
#@export var idle_check_interval : float = 1.0
#@export var idle_chance : float = 0.2
#
#func enter() -> void:
	#super.enter()
	#delay_timer = 0.15
	#idle_chance_timer = 0.0
	#
	#ray_cast_right = parent.get_node("RayCastRight")
	#ray_cast_left = parent.get_node("RayCastLeft")
#
#func process_physics(delta: float) -> State:
	#if not parent.is_on_floor():
		#return slime_fall
#
	#parent.velocity.y += gravity * delta
	#parent.velocity.x = direction * speed
	#return null
#
#func process_frame(delta: float) -> State:
	#if delay_timer > 0.0:
		#delay_timer -= delta
	#else:
		#if ray_cast_right.is_colliding():
			#direction = -1
			#animations.flip_h = true
			#slime_idle.set_direction(direction)
			##print("Slime collided right, going idle.")
			#return slime_idle
#
		#elif ray_cast_left.is_colliding():
			#direction = 1
			#animations.flip_h = false
			#slime_idle.set_direction(direction)
			##print("Slime collided left, going idle.")
			#return slime_idle
	#
	#idle_chance_timer += delta
	#if idle_chance_timer >= idle_check_interval:
		#idle_chance_timer = 0.0
		#if randf() < idle_chance:
			#slime_idle.set_direction()
			##print("Slime randomly began to idle.")
			#return slime_idle
	#
	#return null
