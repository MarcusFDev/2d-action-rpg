class_name Player
extends CharacterBody2D

# Wait until loaded & create variables assigning corresponding nodes,
# the '$' is shorthand for get_node("") method.
@onready var hud: Control = $"../../Interfaces/CanvasLayer/Hud/Hud"
@onready var animations: AnimatedSprite2D = $Animations
@onready var state_machine: Node = $StateMachine
@onready var game_over_menu: Control = $"../../Interfaces/CanvasLayer/Menus/GameOverMenu"
@onready var game_over_timer: Timer = $GameOverDelayTimer

@export var max_health : int = 3
var current_health : int = max_health

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

func take_damage(_amount: int, enemy_velocity: Vector2) -> void:
	if current_health <= 0:
		return
	
	var old_health : int = current_health
	current_health = max(current_health - _amount, 0)
	
	if hud:
		hud.update_health(old_health, current_health)
	
	if current_health <= 0:
		print("You have Died")
		
		var player_death_state: State = state_machine.get_state("PlayerDeath")
		if player_death_state:
			state_machine.change_state(player_death_state)
		else:
			print("Player.gd| Error: Could not find PlayerDeath state!")
		
	else:
		var take_damage_state: State = state_machine.get_state("PlayerTakeDamage")
		if take_damage_state:
			take_damage_state.knockback_source_velocity = enemy_velocity
			state_machine.change_state(take_damage_state)
		else:
			print("Player.gd| Error: Could not find PlayerTakeDamage state!")

func trigger_game_over() -> void:
	print("GameOverTimer started.")
	game_over_timer.start()


func _on_game_over_delay_timer_timeout() -> void:
	print("GameOverTimer finished.")
	game_over_menu.visible = true
	game_over_menu.on_enter()
