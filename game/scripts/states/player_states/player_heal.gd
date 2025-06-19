class_name PlayerHealState
extends State

func enter() -> void:
	super()
	if parent is CharacterBody2D:
		parent.velocity = Vector2.ZERO

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
