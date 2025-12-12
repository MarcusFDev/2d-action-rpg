class_name Player
extends BaseActor

# ===============================
# ===== Actor Intialization =====
# ===============================

func _ready() -> void:
	setup_states()
	setup_signals()

func setup_signals() -> void:
	Global.event_manager.player_spawned.emit(self)
	
	pickup_permission_comp.pickup_received.connect(pickup_signal_receiver)
	hurtbox.hit_received.connect(hit_signal_receiver)
	health_comp.health_empty.connect(death_signal_receiver)
	ground_check_comp.actor_grounded.connect(grounded_signal_receiver)

func setup_states() -> void:
	state_machine.init(self, animations)
	_idle_state()
	_move_state()
	_jump_state()
	_fall_state()
	_heal_state()
	_injured_state()
	_attack_state()

# ==============================
# ===== Actor State Setup ======
# ==============================

func _idle_state() -> void:
	idle_state.handle_physics = func(_delta: float) -> State:
		var is_grounded: bool = ground_check_comp.is_grounded
		if not is_grounded:
			if idle_state.enable_debug:
				print("Player cannot detect floor. Switching to: ", fall_state)
			return fall_state
		if Global.input_manager.is_jump_pressed() and jump_comp.can_jump():
			if idle_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state
		if Global.input_manager.get_movement_axis() != 0:
			if idle_state.enable_debug:
				print("Player Move Key detected. Switching to: ", move_state)
			return move_state
		if Global.input_manager.is_attack_pressed():
			return attack_state
		return null

func _move_state() -> void:
	move_state.handle_physics = func(_delta: float) -> State:
		var is_grounded: bool = ground_check_comp.is_grounded
		if not is_grounded:
			if move_state.enable_debug:
				print("Player cannot detect floor. Switching to: ", fall_state)
			return fall_state
		
		var input_direction: float = Global.input_manager.get_movement_axis()
		if input_direction != 0:
			movement_comp.set_direction(Vector2((input_direction), 0))
		else:
			movement_comp.set_direction(Vector2.ZERO)
		
		movement_comp.process_physics()
		
		if input_direction == 0:
			if move_state.enable_debug:
				print("Player Movement ended. Switching to:", idle_state)
			return idle_state
		
		if Global.input_manager.is_jump_pressed() and jump_comp.can_jump():
			if move_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state
		
		if Global.input_manager.is_attack_pressed():
			return attack_state

		return null

func _jump_state() -> void:
	jump_state.handle_physics = func(_delta: float) -> State:
		var input_direction: float = Global.input_manager.get_movement_axis()
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
		var input_direction: float = Global.input_manager.get_movement_axis()
		var target_speed: float = input_direction * movement_comp.move_speed
		velocity.x = lerp(velocity.x, target_speed, 0.1)
		
		if Global.input_manager.is_jump_pressed() and jump_comp.can_jump():
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
		var input_direction: float = Global.input_manager.get_movement_axis()
		if input_direction == 0:
			if heal_state.enable_debug:
				print("Player Idling detected. switching to: ", idle_state)
			return idle_state
		
		if Global.input_manager.is_jump_pressed() and jump_comp.can_jump():
			if heal_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state
		if Global.input_manager.get_movement_axis() != 0:
			if heal_state.enable_debug:
				print("Player Move Key detected. Switching to: ", move_state)
			return move_state
		if Global.input_manager.is_attack_pressed():
			return attack_state
		
		return null

func _injured_state() -> void:
	injured_state.handle_physics = func(_delta: float) -> State:
		var input_direction: float = Global.input_manager.get_movement_axis()
		if input_direction == 0:
			if injured_state.enable_debug:
				print("Player Idling detected. switching to: ", idle_state)
			return idle_state
		
		if Global.input_manager.is_jump_pressed() and jump_comp.can_jump():
			if injured_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state
		if Global.input_manager.get_movement_axis() != 0:
			if injured_state.enable_debug:
				print("Player Move Key detected. Switching to: ", move_state)
			return move_state
		
		return null

func _attack_state() -> void:
	attack_state.handle_physics = func(_delta: float) -> State:
		var input_direction: float = Global.input_manager.get_movement_axis()
		if input_direction == 0:
			if injured_state.enable_debug:
				print("Player Idling detected. switching to: ", idle_state)
			return idle_state
		
		if Global.input_manager.is_jump_pressed() and jump_comp.can_jump():
			if injured_state.enable_debug:
				print("Player Jump Key detected. Switching to: ", jump_state)
			return jump_state
		if Global.input_manager.get_movement_axis() != 0:
			if injured_state.enable_debug:
				print("Player Move Key detected. Switching to: ", move_state)
			return move_state
		
		return null

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

# ==============================
# ====== Actor Physics =======
# ==============================

func _physics_process(delta: float) -> void:
	gravity_comp.process_physics(delta)
	ground_check_comp.process_physics(delta)
	jump_comp.process_physics(delta)
	state_machine.process_physics(delta)
	
	actor.move_and_slide() 

func _process(delta: float) -> void:
	animation_comp.process_frame()
	state_machine.process_frame(delta)

# ===============================
# === Actor Signal Receivers ====
# ===============================

func grounded_signal_receiver(signal_actor: Node, grounded: bool) -> void:
	if signal_actor == actor:
		if grounded:
			if actor.jump_comp:
				jump_comp.reset_jump_counter()

func pickup_signal_receiver(data: Variant) -> void:
	if data["item_type"] == "health":
		heal_state.set_heal_data(data)
		state_machine.change_state(heal_state)
	if data["item_type"] == "currency":
		if enable_debug:
			print(actor.name, " | Congratulations you collected ",data["item_value"]," coin!")

func hit_signal_receiver(hurtbox_owner: Node, hitbox_data: Variant) -> void:
	if hurtbox_owner == actor:
		injured_state.set_injured_data(hitbox_data)
		state_machine.change_state(injured_state)

func death_signal_receiver() -> void:
	state_machine.change_state(death_state)
