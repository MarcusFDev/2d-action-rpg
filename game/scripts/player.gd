class_name Player
extends CharacterBody2D

# Wait until loaded & create variables assigning corresponding nodes,
# the '$' is shorthand for get_node("") method.
@onready var animations: AnimatedSprite2D = $animations
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Node = $state_machine


# '_ready()' built-in function to run upon scene is ready,
# '-> void' is used to tell the code not to expect any return value. 
func _ready() -> void:
	# Intialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	add_to_group("player")
	state_machine.init(self, animations)

# Upon player key press & nothing else handled it, send that event (input)
# to the state_machine to handle
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

# '_physics_process' built-in function tied to physics engine, runs every frame.
func _physics_process(delta: float) -> void:
	# Trigger 'state_machine' to update movement & physics each frame.
	state_machine.process_physics(delta)

# '_process' built-in function that runs every frame.
func _process(delta: float) -> void:
	# Trigger 'state_machine' to update non-physics each frame.
	state_machine.process_frame(delta)

func take_damage(amount: int, enemy_velocity: Vector2) -> void:
	print("Player.gd| Player takes", amount, "damage!")

	var take_damage_state: State = state_machine.get_state("player_take_damage")
	if take_damage_state:
		take_damage_state.knockback_source_velocity = enemy_velocity
		state_machine.change_state(take_damage_state)
	else:
		print("Player.gd| Error: Could not find PlayerTakeDamage state!")
