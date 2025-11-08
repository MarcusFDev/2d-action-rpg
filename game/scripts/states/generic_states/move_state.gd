class_name MoveState
extends State

@export var actor_path: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("State Settings")
## Determines the animation that plays during the Idle State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var state_animation: String
## Determines whether this state uses its own internal logic or defers to parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all internal logic settings are ignored.
@export var use_parent_logic: bool = false

@export_group("Use Behavior Tree", "export_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_use_behavior_tree: bool = false

@export_subgroup("Enable Random Idle", "export_")
## Determines if entity can randomly idle during movement. [br]
## [b]Note:[/b] Only impacts BehaviorTree driven entities. [br]
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_random_idle: bool = false
## Determines how often the component checks whether the entity should randomly enter an idle state. [br]
## [b]Tip:[/b] Larger values make random idle checks less frequent. [br]
## [b]Note:[/b] Setting to [code]0[/code] disables random idle checks entirely.
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var export_idle_interval: float = 0
## Determines the percentage chance (0–100%) that the entity will decide to idle each time a random check occurs. [br]
## [b]Note:[/b] Low values make random idling rare and natural; higher values increase frequency. [br]
@export_range(0, 100, 1, "suffix:%") var export_idle_chance: float = 0

@export_subgroup("Enable Random Jump", "export_")
## Determines if entity can randomly jump during movement. [br]
## [b]Note:[/b] Only impacts BehaviorTree driven entities. [br]
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_random_jump: bool = false
## Determines how often the component checks whether the entity should randomly enter the jump state. [br]
## [b]Tip:[/b] Larger values make random jump checks less frequent. [br]
## [b]Note:[/b] Setting to [code]0[/code] disables random jump checks entirely.
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var export_jump_interval: float = 0
## Determines the percentage chance (0–100%) that the entity will decide to jump each time a random check occurs. [br]
## [b]Note:[/b] Low values make random jumping rare and natural; higher values increase frequency. [br]
@export_range(0, 100, 1, "suffix:%") var export_jump_chance: float = 0

@export_group("Component Paths")
@export var edge_detector_component: NodePath
@export var movement_component: NodePath
@export var randomizer_component: NodePath

@onready var actor: CharacterBody2D = get_node_or_null(actor_path)
@onready var edge_detector_comp: Node = get_node_or_null(edge_detector_component)
@onready var movement_comp: Node = get_node_or_null(movement_component)
@onready var randomizer_comp: Node = get_node_or_null(randomizer_component)

# Script Variables
var direction: int = 0

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

func enter() -> void:
	super.enter()
	if enable_debug:
		print(
		"===========================\n",
		"MoveState entered by: ", actor.name, "\n",
		"===========================")
	
	init_move()
	
func init_move() -> void:
	actor.animations.play(state_animation)
	enter_callback.call()

func process_physics(delta: float) -> State:
	if use_parent_logic:
		return handle_physics.call(delta)
	
	if export_use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		direction = bb["move_direction"]
	
	movement_comp.set_direction(Vector2(direction, 0))
	movement_comp.apply_physics(delta)

	return null

func process_frame(delta: float) -> State:
	if export_use_behavior_tree:
		var move_dir : int = edge_detector_comp.update(delta)
		var bb : Dictionary = actor.get_blackboard()

		if move_dir != 0:
			direction = move_dir
			bb["move_direction"] = direction
			bb["has_collided"] = true
			bb["can_jump"] = true
		else:
			bb["has_collided"] = false
	
	if export_enable_random_idle:
		var bb: Dictionary = actor.get_blackboard()
		var can_idle : bool = randomizer_comp.randomizer("idle", export_idle_chance, export_idle_interval, delta)
		if can_idle:
			if enable_debug:
				print(actor.name, "MoveState: Random Idle enabled & can idle.")
			bb["force_idle"] = true
			bb["can_patrol"] = false
	
	if export_enable_random_jump:
		var bb: Dictionary = actor.get_blackboard()
		var can_jump : bool = randomizer_comp.randomizer("jump", export_jump_chance, export_jump_interval, delta)
		if can_jump:
			if enable_debug:
				print(actor.name, "MoveState: Random Jump enabled & can jump.")
			bb["force_jump"] = true
			bb["can_jump"] = false

	if use_parent_logic:
		return handle_frame.call(delta)
	
	return null
