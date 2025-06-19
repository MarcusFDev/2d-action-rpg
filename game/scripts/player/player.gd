class_name Player
extends CharacterBody2D

@onready var hud: Control = $"../../Interfaces/CanvasLayer/Hud/Hud"
@onready var animations: AnimatedSprite2D = $Animations
@onready var state_machine: Node = $StateMachine
@onready var game_over_menu: Control = $"../../Interfaces/CanvasLayer/Menus/GameOverMenu"
@onready var game_over_timer: Timer = $GameOverDelayTimer

@export var max_health : int = 9
@export var starting_health : int = 5
var current_health : int = starting_health

# ==============================
# ===== Intialization =====
# ==============================
func _ready() -> void:
	# Intialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	add_to_group("player")
	state_machine.init(self, animations)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	# Trigger 'state_machine' to update movement & physics each frame.
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	# Trigger 'state_machine' to update non-physics each frame.
	state_machine.process_frame(delta)

# ==============================
# ===== Player Health =====
# ==============================
func take_damage(_amount: int, enemy_velocity: Vector2) -> void:
	if current_health <= 0:
		return
	
	var old_health : int = current_health
	current_health = max(current_health - _amount, 0)
	
	if hud:
		hud.update_health(old_health, current_health)
	
	if current_health <= 0:
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

func add_health(_amount: int) -> void:
	var old_health: int = current_health
	current_health = min(current_health + _amount, max_health)
	
	if hud:
		hud.update_health(old_health, current_health)

# ==============================
# ===== GameOver Trigger =====
# ==============================
func trigger_game_over() -> void:
	game_over_timer.start()

func _on_game_over_delay_timer_timeout() -> void:
	game_over_menu.visible = true
	game_over_menu.on_enter()
