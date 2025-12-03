@icon("uid://bnkau76jjea1e")
class_name StateMachine
extends Node

@export var starting_state: State
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

var current_state: State
var blackboard: Dictionary
var state_map : Dictionary = {}
var previous_state_name: String

# Intialize the state machine by giving each child state a refernce to the
# parent object it belongs to and enter the default starting_state.
func init(parent: Node2D, animations: AnimatedSprite2D, bb: Dictionary = {}) -> void:
	blackboard = bb
	for child: Node in get_children():
		if child is State:
			child.parent = parent
			child.animations = animations
			state_map[child.name.to_lower()] = child
	change_state(starting_state)

func change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func get_state(state_name: String) -> State:
	var key: String = state_name.to_lower()
	return state_map.get(key, null)

func process_input(event: InputEvent) -> void:
	var new_state: State = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_physics(delta: float) -> void:
	var new_state: State = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	if blackboard and blackboard.has("intent"):
		var intent: String = blackboard["intent"]
		if intent:
			var key: String = (intent + "state").to_lower()
			if state_map.has(key):
				var desired_state: State = state_map[key]
				if desired_state != current_state:
					if enable_debug:
						print("State Machine | State Change due to intent: ", intent)
					change_state(desired_state)
	
	if enable_debug:
		var current_state_name : Variant = current_state.name
		if current_state_name != previous_state_name:
			previous_state_name = current_state_name
			print("==============================")
			print("[STATE CHANGE] →", current_state_name)
			for key: Variant in blackboard.keys():
				print(" ", key, ":", blackboard[key])
			print("==============================")
	
	if current_state:
		var new_state: State = current_state.process_frame(delta)
		if new_state:
			change_state(new_state)
