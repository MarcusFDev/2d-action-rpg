class_name SlimeFallState
extends State

#@export var slime_patrol: MoveState
#
#func enter() -> void:
	#super.enter()
	#animations.play("slime_fall")
	#
#func process_physics(delta: float) -> State:
	#parent.velocity.y += gravity * delta
	#
	#if parent.is_on_floor():
		##print("Slime has stopped falling, going on patrol")
		#return slime_patrol
	#
	#return null
