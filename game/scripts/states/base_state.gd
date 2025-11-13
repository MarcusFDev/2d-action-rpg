@icon("uid://bnkau76jjea1e")
class_name State
extends Node

# Script Variables.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var parent: Node2D
var animations: AnimatedSprite2D

func enter() -> void:
	#print("Entered state: ", parent.name, name)
	pass

func exit() -> void:
	#print("Exited state: ", parent.name, name)
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
