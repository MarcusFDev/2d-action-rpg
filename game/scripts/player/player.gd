class_name Player
extends CharacterBody2D

@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Actor Settings")
@export var animations_path: NodePath

@export_group("Temporary Options")
@export var damage: int = 1
@export var game_over_menu_path: NodePath
@export var game_over_timer_path: NodePath

@export_group("State Paths")
@export var state_machine_path: NodePath
@export var idle_state_path: NodePath
@export var move_state_path: NodePath
@export var jump_state_path: NodePath
@export var fall_state_path: NodePath
@export var attack_state_path: NodePath
@export var injured_state_path: NodePath
@export var heal_state_path: NodePath
@export var death_state_path: NodePath

@export_group("Component Paths")
@export var ground_check_component: NodePath
@export var animation_component: NodePath
@export var movement_component: NodePath
@export var jump_component: NodePath
@export var gravity_component: NodePath
@export var pickup_permission_component: NodePath
@export var hurtbox_component: NodePath
@export var hitbox_component: NodePath

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
@onready var injured_state: Node = get_node_or_null(injured_state_path)
@onready var heal_state: Node = get_node_or_null(heal_state_path)
@onready var death_state: Node = get_node_or_null(death_state_path)
	
@onready var ground_check_comp: Node = get_node_or_null(ground_check_component)
@onready var animation_comp: Node = get_node_or_null(animation_component)
@onready var movement_comp: Node = get_node_or_null(movement_component)
@onready var jump_comp: Node = get_node_or_null(jump_component)
@onready var gravity_comp: Node = get_node_or_null(gravity_component)
@onready var pickup_permission_comp: Node = get_node_or_null(pickup_permission_component)
@onready var hurtbox_comp: Area2D = get_node_or_null(hurtbox_component)
@onready var hitbox_comp: Area2D = get_node_or_null(hitbox_component)

# ==============================
# ===== Intialization =====
# ==============================
func _ready() -> void:
	_setup_states()
	_setup_signals()
	state_machine.init(self, animations)

func _setup_signals() -> void:
	pickup_permission_comp.pickup_received.connect(pickup_received)
	hurtbox_comp.hit_received.connect(hit_received)

# ==============================
# ===== Player State Setup =====
# ==============================

func _setup_states() -> void:
	_idle_state()
	_move_state()
	_jump_state()
	_fall_state()
	_heal_state()
	_injured_state()

func _idle_state() -> void:
	idle_state.handle_physics = func(_delta: float) -> State:
		var is_grounded: bool = ground_check_comp.is_grounded
		if not is_grounded:
			if idle_state.enable_debug:
				print("Player cannot detect floor. Switching to: ", fall_state)
			return fall_state
		if InputManagerClass.is_jump_pressed() and jump_comp.can_jump():
			if idle_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state
		if InputManagerClass.get_movement_axis() != 0:
			if idle_state.enable_debug:
				print("Player Move Key detected. Switching to: ", move_state)
			return move_state
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

func _heal_state() -> void:
	heal_state.handle_physics = func(_delta: float) -> State:
		var input_direction: float = InputManagerClass.get_movement_axis()
		if input_direction == 0:
			if heal_state.enable_debug:
				print("Player Idling detected. switching to: ", idle_state)
			return idle_state
		
		if InputManagerClass.is_jump_pressed() and jump_comp.can_jump():
			if heal_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state
		if InputManagerClass.get_movement_axis() != 0:
			if heal_state.enable_debug:
				print("Player Move Key detected. Switching to: ", move_state)
			return move_state
		
		return null

func _injured_state() -> void:
	injured_state.handle_physics = func(_delta: float) -> State:
		var input_direction: float = InputManagerClass.get_movement_axis()
		if input_direction == 0:
			if injured_state.enable_debug:
				print("Player Idling detected. switching to: ", idle_state)
			return idle_state
		
		if InputManagerClass.is_jump_pressed() and jump_comp.can_jump():
			if injured_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state
		if InputManagerClass.get_movement_axis() != 0:
			if injured_state.enable_debug:
				print("Player Move Key detected. Switching to: ", move_state)
			return move_state
		
		return null

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	trigger_attack()

func _physics_process(delta: float) -> void:
	ground_check_comp.apply(delta)
	gravity_comp.apply_physics(delta)

	if ground_check_comp.just_landed():
		jump_comp.reset_jump_counter()

	animation_comp.animation_flip(delta)
	state_machine.process_physics(delta)
	jump_comp.update_timer(delta)
	actor.move_and_slide() 
	ground_check_comp.post_update()

func pickup_received(data: Variant) -> void:
	if data["type"] == "heal":
		heal_state.set_heal_data(data)
		state_machine.change_state(heal_state)
	if data["type"] == "currency":
		print(actor.name, " | Congratulations you collected a coin!")

func hit_received(hurtbox_owner: Node, hitbox_data: Variant) -> void:
	if hurtbox_owner == actor:
		injured_state.set_injured_data(hitbox_data)
		state_machine.change_state(injured_state)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func trigger_attack() -> void:
	if InputManagerClass.is_attack_pressed():
		if attack_state:
			state_machine.change_state(attack_state)

# ==============================
# ===== GameOver Trigger =====
# ==============================
func trigger_game_over() -> void:
	game_over_timer.start()

func _on_game_over_delay_timer_timeout() -> void:
	game_over_menu.visible = true
	game_over_menu.on_enter()
