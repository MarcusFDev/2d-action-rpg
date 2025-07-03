class_name PlayerHealState
extends State

#@onready var timer: Timer = $PlayerHealTimer
#@export var idle: State
#var finished : bool = false
#
#func enter() -> void:
	#super()
	#if parent is CharacterBody2D:
		#parent.velocity = Vector2.ZERO
	#finished = false
	#animations.play("heal")
	#
	#if not timer.is_connected("timeout", _on_player_heal_timer_timeout):
		#timer.connect("timeout", _on_player_heal_timer_timeout)
	#timer.start()
#
#
#func _on_player_heal_timer_timeout() -> void:
	#finished = true
#
#
#func process_frame(_delta: float) -> State:
	#if finished:
		#return idle
	#return null
