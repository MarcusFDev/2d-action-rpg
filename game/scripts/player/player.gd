class_name Player
extends CharacterBody2D

@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Actor Settings")
@export var animations_path: NodePath

@export_group("Temporary Options")
@export var game_over_menu_path: NodePath
@export var game_over_timer_path: NodePath

@export_group("State Paths")
@export var state_machine_path: NodePath
@export var idle_state_path: NodePath
@export var move_state_path: NodePath
@export var jump_state_path: NodePath
@export var fall_state_path: NodePath
@export var attack_state_path: NodePath
@export var hurt_state_path: NodePath
@export var heal_state_path: NodePath
@export var death_state_path: NodePath

@export_group("Component Paths")
@export var ground_check_component: NodePath
@export var animation_component: NodePath
@export var movement_component: NodePath
@export var jump_component: NodePath
@export var gravity_component: NodePath

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)
@onready var animations: AnimatedSprite2D = get_node_or_null(animations_path)
@onready var game_over_menu: Node = get_node_or_null(game_over_menu_path)
@onready var game_over_timer: Node = get_node_or_null(game_over_timer_path)
	
@onready var state_machine: Node = get_node_or_null(state_machine_path)
@onready var idle_state: Node = get_node_or_null(idle_state_path)
@onready var move_state: Node = get_node_or_null(move_state_path)
@onready var jump_state: Node = get_node_or_null(jump_state_path)
@onready var fall_state: Node = get_node_or_null(fall_state_path)
@onready var attack_state: Node = get_node_or_null(attack_state_path)
@onready var hurt_state: Node = get_node_or_null(hurt_state_path)
@onready var heal_state: Node = get_node_or_null(heal_state_path)
@onready var death_state: Node = get_node_or_null(death_state_path)
	
@onready var ground_check_comp: Node = get_node_or_null(ground_check_component)
@onready var animation_comp: Node = get_node_or_null(animation_component)
@onready var movement_comp: Node = get_node_or_null(movement_component)
@onready var jump_comp: Node = get_node_or_null(jump_component)
@onready var gravity_comp: Node = get_node_or_null(gravity_component)

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
		if InputManagerClass.is_jump_pressed() and jump_comp.can_jump():
			if idle_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state
		if InputManagerClass.get_movement_axis() != 0:
			if idle_state.enable_debug:
				print("Player Move Key detected. Switching to: ", move_state)
			return move_state
		return null
	
	idle_state.handle_physics = func(_delta: float) -> State:
		var is_grounded: bool = ground_check_comp.is_grounded
		if not is_grounded:
			if idle_state.enable_debug:
				print("Player cannot detect floor. Switching to: ", fall_state)
			return fall_state
		move_and_slide()
		return null

func _move_state() -> void:
	move_state.handle_physics = func(_delta: float) -> State:
		var is_grounded: bool = ground_check_comp.is_grounded
		if not is_grounded:
			if move_state.enable_debug:
				print("Player cannot detect floor. Switching to: ", fall_state)
			return fall_state
		
		var input_direction: float = InputManagerClass.get_movement_axis()
		if input_direction != 0:
			movement_comp.set_direction(Vector2((input_direction), 0))
		else:
			movement_comp.set_direction(Vector2.ZERO)
		
		movement_comp.apply_physics(_delta)
		
		if input_direction == 0:
			if move_state.enable_debug:
				print("Player Movement ended. Switching to:", idle_state)
			return idle_state
		
		if InputManagerClass.is_jump_pressed() and jump_comp.can_jump():
			if move_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state

		return null

func _jump_state() -> void:
	jump_state.handle_physics = func(_delta: float) -> State:
		var input_direction: float = InputManagerClass.get_movement_axis()
		if input_direction != 0:
			var movement: float = input_direction * movement_comp.move_speed 
			velocity.x = lerp(velocity.x, movement, 0.1)

		if velocity.y > 0:
			if jump_state.enable_debug:
				print("Player is falling. Switching to: ", fall_state)
			return fall_state
		return null

func _fall_state() -> void:
	fall_state.handle_physics = func(_delta: float) -> State:
		var input_direction: float = InputManagerClass.get_movement_axis()
		var target_speed: float = input_direction * movement_comp.move_speed
		velocity.x = lerp(velocity.x, target_speed, 0.1)
		
		move_and_slide()
		
		if InputManagerClass.is_jump_pressed() and jump_comp.can_jump():
			if move_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state

		var is_grounded: bool = ground_check_comp.is_grounded
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
	ground_check_comp.apply(delta)
	if ground_check_comp.just_landed():
		jump_comp.reset_jump_counter()

	animation_comp.animation_flip(delta)
	state_machine.process_physics(delta)
	jump_comp.update_timer(delta)
	
	ground_check_comp.post_update()

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func trigger_attack() -> void:
	if InputManagerClass.is_attack_pressed():
		if attack_state:
			state_machine.change_state(attack_state)

#func apply_knockback(direction: Vector2, force: float) -> void:
	#velocity += direction.normalized() * force

# ==============================
# ===== GameOver Trigger =====
# ==============================
func trigger_game_over() -> void:
	game_over_timer.start()

func _on_game_over_delay_timer_timeout() -> void:
	game_over_menu.visible = true
	game_over_menu.on_enter()
