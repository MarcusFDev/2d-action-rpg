class_name StateMachine
extends Node

@export var starting_state: State
var current_state: State

# Intialize the state machine by giving each child state a refernce to the
# parent object it belongs to and enter the default starting_state.
func init(parent: Node2D, animations: AnimatedSprite2D) -> void:
	for child: Node in get_children():
		if child is State:
			child.parent = parent
			child.animations = animations
	change_state(starting_state)

func change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func get_state(state_name: String) -> State:
	for child: Node in get_children():
		if child is State and child.name == state_name:
			return child
	return null

func process_input(event: InputEvent) -> void:
	var new_state: State = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_physics(delta: float) -> void:
	var new_state: State = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state: State = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
