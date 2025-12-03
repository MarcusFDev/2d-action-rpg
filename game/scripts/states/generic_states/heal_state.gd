class_name HealState
extends State

## Assign the parent entity to the state.
@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("State Settings")
## Determines the animation that plays during the Heal State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var state_animation : String
## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_parent_logic: bool = false
@export var use_behavior_tree: bool = false

# Script Variables
@onready var actor: Node = get_node_or_null(actor_path)

# Callback Functions
func _on_enter() -> void: pass
func _on_input(_event: InputEvent) -> void: pass
func _on_physics(_delta: float) -> void: pass
func _on_frame(_delta: float) -> void: pass

# Callback Variables
var enter_callback: Callable = _on_enter
var handle_input: Callable = _on_input
var handle_physics: Callable = _on_physics
var handle_frame: Callable = _on_frame

var animation_finished: bool
var heal_amount: float = 0.0

func enter() -> void:
	super.enter()
	if enable_debug:
		print(
		"===========================\n",
		"HealState entered by: ", actor.name, "\n",
		"===========================")
	
	init_heal()

func init_heal() -> void:
	actor.animations.play(state_animation)
	animation_finished = false
	
	if use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		bb["locked"] = true

func process_physics(delta: float) -> State:
	actor.velocity.x = 0

	if animation_finished:
		if actor.health_comp:
			if enable_debug:
				print(actor.name, " | HealState: Calling HealthComponent with heal_value: ", heal_amount)
			actor.health_comp.gain_health(heal_amount)
		
		if use_behavior_tree:
			var bb: Dictionary = actor.get_blackboard()
			bb["force_heal"] = false
			bb["locked"] = false
		
		if use_parent_logic:
			return handle_physics.call(delta)
	
	return null

func process_frame(delta: float) -> State:
	if use_parent_logic:
		return handle_frame.call(delta)
	return null

func process_input(event: InputEvent) -> State:
	if use_parent_logic:
		if animation_finished:
			return handle_input.call(event)
	return null

func set_heal_data(data: Dictionary) -> void:
	heal_amount = data["item_value"]

func on_animation_finished() -> void:
	if actor.animations.animation == state_animation:
		if enable_debug:
			print(actor.name, " | HealState: Animation finished.")
		animation_finished = true

func exit() -> void:
	if enable_debug:
		print(actor.name, " | HealState exited.")
