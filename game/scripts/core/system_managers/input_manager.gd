class_name InputManagerClass
extends Node

static func is_jump_pressed() -> bool:
	return Input.is_action_just_pressed("jump")

static func get_movement_axis() -> float:
	return Input.get_axis("move_left", "move_right")

static func is_attack_pressed() -> bool:
	return Input.is_action_just_pressed("attack")

static func is_pause_pressed() -> bool:
	return Input.is_action_just_pressed("pause")
