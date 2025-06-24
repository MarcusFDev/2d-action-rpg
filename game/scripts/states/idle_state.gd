class_name IdleState
extends State

@export var jump_force: float = -300
@export var use_idle_timer: bool = false
@export var min_idle_time: float = 1.0
@export var max_idle_time: float = 3.0
@export var next_state: State = null
@export var use_callbacks: bool = false

# Internal timer for enemy AI
var idle_timer: float = 0.0
var target_idle_time: float = 1.0
var direction: int = 1

# Callbacks (used by player)
var enter_callback: Callable = func(): return
var handle_input: Callable = func(_event): return null
var handle_physics: Callable = func(_delta): return null
var handle_frame: Callable = func(_delta): return null

func enter() -> void:
	super.enter()
	idle_timer = 0.0
	target_idle_time = randf_range(min_idle_time, max_idle_time)
	set_direction()
	if parent:
		parent.velocity.x = 0
	enter_callback.call()

func exit() -> void:
	pass

func set_direction(dir: Variant = null) -> void:
	if dir == null:
		direction = -1 if randf() < 0.5 else 1
	else:
		direction = dir

func process_input(event: InputEvent) -> State:
	return handle_input.call(event)

func process_physics(delta: float) -> State:
	if use_callbacks:
		var result = handle_physics.call(delta)
		if result != null:
			return result
		return null
	else:
		if parent:
			if not parent.is_on_floor():
				return next_state  # For enemies that fall out of idle
			parent.velocity.y += gravity * delta
			parent.move_and_slide()
		return null

func process_frame(delta: float) -> State:
	var result = handle_frame.call(delta)
	if result != null:
		return result

	if use_idle_timer:
		idle_timer += delta
		if idle_timer >= target_idle_time:
			return next_state  # Enemies only
	return null
