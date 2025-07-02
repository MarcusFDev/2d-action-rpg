class_name PlayerDeathState
extends State


#func enter() -> void:
	#super()
	#if parent is CharacterBody2D:
		#parent.velocity = Vector2.ZERO
	#if not animations.animation_finished.is_connected(Callable(self, "_on_animations_animation_finished")):
		#animations.animation_finished.connect(_on_animations_animation_finished, CONNECT_ONE_SHOT)
#
#func process_input(_event: InputEvent) -> State:
	#return null
#
#func process_physics(_delta: float) -> State:
	#return null
#
#func _on_animations_animation_finished() -> void:
	#if animations.animation == "death":
		#if parent.has_method("trigger_game_over"):
			#parent.trigger_game_over()
