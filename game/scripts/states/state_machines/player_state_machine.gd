extends Node

@export var starting_state: State

var current_state: State

# Intialize the state machine by giving each child state a refernce to the
# parent object it belongs to and enter the default starting_state.
func init(parent: Node2D, animations: AnimatedSprite2D) -> void:
	for child in get_children():
		if child is State:
			child.parent = parent
			child.animations = animations
	
	# Intialize to the default state
	change_state(starting_state)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
