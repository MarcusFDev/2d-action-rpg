class_name Player
extends CharacterBody2D

@onready var hud: Control = $"../../Interfaces/CanvasLayer/Hud/Hud"
@onready var animations: AnimatedSprite2D = $Animations
@onready var state_machine: Node = $StateMachine
@onready var game_over_menu: Control = $"../../Interfaces/CanvasLayer/Menus/GameOverMenu"
@onready var game_over_timer: Timer = $GameOverDelayTimer

@onready var idle_state: IdleState = $StateMachine/IdleState
@onready var move_state: MoveState = $StateMachine/MoveState
@onready var jump_state: State = $StateMachine/PlayerJump
@onready var fall_state: State = $StateMachine/PlayerFall

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
	_setup_states()
	state_machine.init(self, animations)
	call_deferred("_post_ready_check")

func _post_ready_check():
	if not is_on_floor():
		state_machine.change_state(fall_state)

# ==============================
# ===== Player State Setup =====
# ==============================

func _setup_states():
	_idle_state()
	_move_state()

func _idle_state():
	idle_state.handle_input = func(event):
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = idle_state.jump_force
			return jump_state
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			return move_state
		return null
	
	idle_state.handle_physics = func(delta):
		print("Idle physics for player running")
		if not is_on_floor():
			return fall_state
		velocity.y += idle_state.gravity * delta
		move_and_slide()
		return null
	
	idle_state.enter_callback = func():
		animations.play("idle")

func _move_state():

	move_state.handle_input = func(event): return null

	move_state.handle_physics = func(delta):
		if not is_on_floor():
			return fall_state

		velocity.y += move_state.gravity * delta

		var input_direction: float = Input.get_axis("move_left", "move_right")
		var movement: float = input_direction * move_state.move_speed

		if movement == 0:
			return idle_state

		animations.flip_h = movement < 0
		velocity.x = movement

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -300  # or use a property if you want to export it
			return jump_state

		move_and_slide()
		return null

	move_state.enter_callback = func():
		animations.play("move")

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
	
	var player_heal_state: State = state_machine.get_state("PlayerHeal")
	if player_heal_state:
		state_machine.change_state(player_heal_state)
	
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
