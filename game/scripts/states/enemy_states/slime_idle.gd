class_name SlimeIdleState
extends State

#@export var min_idle_time : float = 1.0
#@export var max_idle_time : float = 3.0
#@export var slime_patrol: SlimePatrolState
#@export var slime_fall: SlimeFallState
#
#var direction : int = 1
#var idle_timer : float = 0.0
#var target_idle_time : float = 1.0
#
#func set_direction(dir : Variant = null) -> void:
	#if dir == null:
		#direction = -1 if randf() < 0.5 else 1
	#else:
		#direction = dir
#
#func enter() -> void:
	#super.enter()
	#idle_timer = 0.0
	#target_idle_time = randf_range(min_idle_time, max_idle_time)
	#parent.velocity.x = 0
#
#func process_physics(delta: float) -> State:
	#if not parent.is_on_floor():
		#return slime_fall
#
	#parent.velocity.y += gravity * delta
	#return null
#
#func process_frame(delta: float) -> State:
	#idle_timer += delta
	#if idle_timer >= target_idle_time:
		#slime_patrol.direction = direction
		#return slime_patrol
	#return null
