class_name IdleState
extends State

## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_internal_logic: bool = true
## Determines the animation that plays during the Idle State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var idle_animation : String
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_group("Internal Logic Settings")

## Assign State node to transition to when  [code]next_state[/code]  is called. [br]
## [b]Note:[/b] Idle state will transition automatically to this node.
@export var next_state: State = null
## ## Assign State node to transition to when  [code]fall_state[/code]  is called. [br]
@export var fall_state: State = null
## Determines whether entity uses a idle timer to control how long it remains in this state. [br]
## [b]Note:[/b] If set to  [code]false[/code]  state does not transition on it's own.
@export var use_idle_timer: bool = false
## Determines the minimum time a entity can be idle for.[br]
## [b]Note:[/b] Can exceed 5 seconds with manual input.[br] 
## [b]Requires idle timer set to  [code]true[/code]  to take effect.[/b]
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var min_idle_time: float = 1.0
## Determines the maximum time a entity can be idle for.[br]
## [b]Note:[/b] Can exceed 5 seconds with manual input.[br] 
## [b]Requires idle timer set to  [code]true[/code]  to take effect.[/b]
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var max_idle_time: float = 3.0

var idle_timer: float = 0.0
var target_idle_time: float = 1.0
var direction: int = 1

# Callbacks
var enter_callback: Callable = func(): return
var handle_input: Callable = func(_event): return null
var handle_physics: Callable = func(_delta): return null
var handle_frame: Callable = func(_delta): return null

func enter() -> void:
	super.enter()
	init_idle()

func init_idle() -> void:
	parent.animations.play(idle_animation)
	enter_callback.call()
	set_direction()
	if parent:
		parent.velocity.x = 0
	if enable_debug:
		print(
			"\n===== Idle State: ===== \n", parent,
			"\nAnimation playing: ", idle_animation)

	if use_internal_logic:
		if enable_debug:
			print("Internal logic enabled.")
		if idle_timer:
			idle_timer = 0.0
			target_idle_time = randf_range(min_idle_time, max_idle_time)
			if enable_debug:
				print(
					"Idle timer enabled.\n",
					"Target idle time: ", target_idle_time, " seconds.")
		else:
			print("Idle Timer disabled.")
	else:
		if enable_debug:
			print("Internal logic disabled.")	

func set_direction(dir: Variant = null) -> void:
	if dir == null:
		direction = -1 if randf() < 0.5 else 1
	else:
		direction = dir

func process_input(event: InputEvent) -> State:
	return handle_input.call(event)

func process_physics(delta: float) -> State:
	if use_internal_logic:
		if not parent.is_on_floor():
			if enable_debug:
				print("Cannot detect floor. Switching to: ", fall_state)
			return fall_state
		parent.velocity.y += gravity * delta
		parent.move_and_slide()
	else:
		return handle_physics.call(delta)
	return null

func process_frame(delta: float) -> State:
	if use_internal_logic:
		if use_idle_timer:
			idle_timer += delta
			if idle_timer >= target_idle_time:
				return next_state
	else:
		return handle_frame.call(delta)

	return null
