class_name Slime
extends BaseActor

# ===============================
# ===== Actor Intialization =====
# ===============================

func _ready() -> void:
	setup_states()
	setup_signals()
	actor_blackboard()
	actor_behavior_tree()

func setup_signals() -> void:
	pickup_permission_comp.pickup_received.connect(pickup_signal_receiver)
	hurtbox.hit_received.connect(hit_signal_receiver)
	health_comp.health_empty.connect(death_signal_receiver)
	ground_check_comp.actor_grounded.connect(grounded_signal_receiver)
	Global.event_manager.actor_died.connect(destroy_actor)

func setup_states() -> void:
	state_machine.init(self, animations, blackboard)
	_idle_state()
	_patrol_state()
	_jump_state()
	_fall_state()
	_heal_state()
	_injured_state()
	_death_state()

# ===============================
# ==== Actor Behavior Tree ======
# ===============================

func actor_blackboard() -> void:
	blackboard["fsm"] = state_machine
	
	blackboard["is_grounded"] = false
	blackboard["has_collided"] = false
	
	blackboard["force_idle"] = false
	blackboard["force_jump"] = false
	blackboard["force_patrol"] = false
	blackboard["force_heal"] = false
	blackboard["force_injure"] = false
	
	blackboard["can_patrol"] = true
	blackboard["can_idle"] = true
	blackboard["can_jump"] = true
	blackboard["can_die"] = false
	
	blackboard["locked"] = false
	blackboard["move_direction"] = 1
	blackboard["intent"] = "Fall" # Note: Must Match StateMachine Starting State

func actor_behavior_tree() -> void:
	bt_root = BTSelector.new([
		BTSequence.new([
			BTCondition.new("is_grounded", false),
			BTCondition.new("locked", false),
			BTAction.new("Fall")
		]),
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("force_idle", true),
			BTCondition.new("locked", false),
			BTAction.new("Idle")
		]),
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("force_jump", true),
			BTCondition.new("locked", false),
			BTAction.new("Jump")
		]),
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("force_patrol", true),
			BTCondition.new("locked", false),
			BTAction.new("Move")
		]),
		BTSequence.new([
			BTCondition.new("force_heal", true),
			BTCondition.new("locked", false),
			BTAction.new("Heal")
		]),
		BTSequence.new([
			BTCondition.new("force_injure", true),
			BTCondition.new("locked", false),
			BTAction.new("Injured")
		]),
		BTSequence.new([
			BTCondition.new("can_die", true),
			BTAction.new("Death")
		]),
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("has_collided", false),
			BTCondition.new("can_patrol", true),
			BTCondition.new("locked", false),
			BTAction.new("Move")
		]),
		BTSequence.new([
			BTCondition.new("is_grounded", true),
			BTCondition.new("has_collided", true),
			BTCondition.new("locked", false),
			BTSelector.new([
				BTSequence.new([
					BTCondition.new("can_jump", true),
					BTCondition.new("random_chance", 0.50),
					BTCondition.new("locked", false),
					BTAction.new("Jump"),
				]),
				BTSequence.new([
					BTCondition.new("can_idle", true),
					BTCondition.new("locked", false),
					BTAction.new("Idle")
				])
			])
		]),
	])
	behavior_tree = BehaviorTree.new(bt_root, blackboard, self)

# ==============================
# ===== Actor State Setup ======
# ==============================

func _idle_state() -> void:
	pass

func _patrol_state() -> void:
	pass

func _jump_state() -> void:
	pass

func _fall_state() -> void:
	pass

func _heal_state() -> void:
	pass

func _injured_state() -> void:
	pass

func _death_state() -> void:
	pass

# ==============================
# ====== Actor Physics =======
# ==============================

func _physics_process(delta: float) -> void:
	ground_check_comp.process_physics(delta)
	state_machine.process_physics(delta)
	gravity_comp.process_physics(delta)
	jump_comp.process_physics(delta)
	
	actor.move_and_slide()
	
func _process(delta: float) -> void:
	behavior_tree.process_frame()
	animation_comp.process_frame()
	state_machine.process_frame(delta)

# ===============================
# === Actor Signal Receivers ====
# ===============================

func grounded_signal_receiver(signal_actor: Node, grounded: bool) -> void:
	if signal_actor == actor:
		if grounded:
			blackboard["is_grounded"] = true
		else:
			blackboard["is_grounded"] = false

func death_signal_receiver() -> void:
	blackboard["can_die"] = true

func pickup_signal_receiver(data: Variant) -> void:
	if data["item_type"] == "health":
		blackboard["pickup_data"] = data["item_value"]
		blackboard["force_heal"] = true
		blackboard["locked"] = false

func hit_signal_receiver(hurtbox_owner: Node, hitbox_data: Variant) -> void:
	if hurtbox_owner == actor:
		blackboard["hitbox_data"] = hitbox_data
		blackboard["force_injure"] = true
		blackboard["locked"] = false
