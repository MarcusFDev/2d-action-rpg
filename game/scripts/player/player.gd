class_name Player
extends CharacterBody2D

@onready var hud: Control = $"../../Interfaces/CanvasLayer/Hud/Hud"
@onready var animations: AnimatedSprite2D = $Animations
@onready var state_machine: Node = $StateMachine
@onready var game_over_menu: Control = $"../../Interfaces/CanvasLayer/Menus/GameOverMenu"
@onready var game_over_timer: Timer = $GameOverDelayTimer

# Player Components
@onready var gravity_component: Node = $Components/GravityComponent
@onready var ground_check_component: Node = $Components/GroundCheckComponent
@onready var flip_component: Node = $Components/DirectionFlipComponent
@onready var movement_component: Node = $"Components/MovementComponent"
@onready var jump_component: Node = $Components/JumpComponent

# Generic States
@onready var idle_state: IdleState = $StateMachine/IdleState
@onready var move_state: MoveState = $StateMachine/MoveState
@onready var jump_state: JumpState = $StateMachine/JumpState
@onready var fall_state: FallState = $StateMachine/FallState
@onready var heal_state: HealState = $StateMachine/HealState
@onready var hurt_state: HurtState = $StateMachine/HurtState
@onready var attack_state: AttackState =$StateMachine/AttackState
@onready var death_state: DeathState = $StateMachine/DeathState

@export var max_health : int = 9
@export var starting_health : int = 5

# Script Variables
var current_health : int = starting_health

# ==============================
# ===== Intialization =====
# ==============================
func _ready() -> void:
	_setup_states()
	state_machine.init(self, animations)

# ==============================
# ===== Player State Setup =====
# ==============================

func _setup_states() -> void:
	_idle_state()
	_move_state()
	_jump_state()
	_fall_state()

func _idle_state() -> void:
	idle_state.handle_input = func(_event: InputEvent) -> State:
		var is_grounded: bool = ground_check_component.is_grounded
		if InputManagerClass.is_jump_pressed() and is_grounded:
			if idle_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state
		if InputManagerClass.get_movement_axis() != 0:
			if idle_state.enable_debug:
				print("Player Move Key detected. Switching to: ", move_state)
			return move_state
		return null
	
	idle_state.handle_physics = func(_delta: float) -> State:
		var is_grounded: bool = ground_check_component.is_grounded
		if not is_grounded:
			if idle_state.enable_debug:
				print("Player cannot detect floor. Switching to: ", fall_state)
			return fall_state
		move_and_slide()
		return null

func _move_state() -> void:
	move_state.handle_physics = func(_delta: float) -> State:
		var is_grounded: bool = ground_check_component.is_grounded
		if not is_grounded:
			if move_state.enable_debug:
				print("Player cannot detect floor. Switching to: ", fall_state)
			return fall_state
		
		var input_direction: float = InputManagerClass.get_movement_axis()
		if input_direction != 0:
			movement_component.set_direction(Vector2((input_direction), 0))
		else:
			movement_component.set_direction(Vector2.ZERO)
		
		movement_component.apply(_delta)
		
		if input_direction == 0:
			if move_state.enable_debug:
				print("Player Movement ended. Switching to:", idle_state)
			return idle_state
		
		if InputManagerClass.is_jump_pressed() and is_grounded:
			if move_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state

		return null

func _jump_state() -> void:
	jump_state.handle_physics = func(_delta: float) -> State:
		var input_direction: float = InputManagerClass.get_movement_axis()
		if input_direction != 0:
			var movement: float = input_direction * movement_component.move_speed 
			velocity.x = lerp(velocity.x, movement, 0.1)

		if velocity.y > 0:
			if jump_state.enable_debug:
				print("Player is falling. Switching to: ", fall_state)
			return fall_state
		return null

func _fall_state() -> void:
	fall_state.handle_physics = func(_delta: float) -> State:
		var input_direction: float = InputManagerClass.get_movement_axis()
		var target_speed: float = input_direction * movement_component.move_speed
		velocity.x = lerp(velocity.x, target_speed, 0.1)
		
		move_and_slide()
		
		var is_grounded: bool = ground_check_component.is_grounded
		if is_grounded:
			var movement: float = velocity.x
			if movement != 0:
				if fall_state.enable_debug:
					print("Player landed and is moving. Switching to: ", move_state)
				return move_state
			else:
				if fall_state.enable_debug:
					print("Player landed and is idle. Switching to: ", idle_state)
				return idle_state
		return null

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	trigger_attack()

func _physics_process(delta: float) -> void:
	ground_check_component.apply(delta)
	flip_component.apply(delta)
	state_machine.process_physics(delta)
	jump_component.update_timer(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

# ==============================
# ===== Player Health =====
# ==============================
func take_damage(_amount: int, enemy_position: Vector2) -> void:
	if current_health <= 0:
		return
	
	var old_health : int = current_health
	current_health = max(current_health - _amount, 0)
	
	if hud:
		hud.update_health(old_health, current_health)
	
	if current_health <= 0:
		if death_state:
			state_machine.change_state(death_state)
		else:
			print("Player.gd| Error: Could not find Death State!")
		
	else:
		if hurt_state:
			var knockback_dir : Vector2 = (global_position - enemy_position).normalized()
			hurt_state.set_knockback_data(knockback_dir)
			state_machine.change_state(hurt_state)
		else:
			print("Player.gd| Error: Could not find Hurt state!")

func trigger_attack() -> void:
	if InputManagerClass.is_attack_pressed():
		if attack_state:
			state_machine.change_state(attack_state)

func add_health(_amount: int) -> void:
	var old_health: int = current_health
	current_health = min(current_health + _amount, max_health)

	if heal_state:
		state_machine.change_state(heal_state)
	if hud:
		hud.update_health(old_health, current_health)

func apply_knockback(direction: Vector2, force: float) -> void:
	velocity += direction.normalized() * force

func apply_immunity(_duration: float) -> void:
	#is_immune = true
	#$ImmunityTimer.start(duration)
	pass
# ==============================
# ===== GameOver Trigger =====
# ==============================
func trigger_game_over() -> void:
	game_over_timer.start()

func _on_game_over_delay_timer_timeout() -> void:
	game_over_menu.visible = true
	game_over_menu.on_enter()
