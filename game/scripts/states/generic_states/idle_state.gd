class_name IdleState
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

@export_subgroup("Enable Randomize Direction", "export_")
## Determines if entity can randomly change direction during movement. [br]
## [b]Note:[/b] Only impacts BehaviorTree driven entities. [br]
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_randomize_direction: bool = false
## Determines how often the state checks whether the entity should randomly change direction. [br]
## [b]Tip:[/b] Larger values make random direction swaps less frequent. [br]
## [b]Note:[/b] Setting to [code]0[/code] disables random direction swaps entirely.
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var export_swap_interval: float = 0
## Determines the percentage chance (0–100%) that the entity will decide to swap direction each time a random check occurs. [br]
## [b]Note:[/b] Low values make random direction changing rare and natural; higher values increase frequency. [br]
@export_range(0, 100, 1, "suffix:%") var export_swap_chance: float = 0

@export_subgroup("Enable Random Patrol", "export_")
## Determines if entity can randomly patrols during movement. [br]
## [b]Note:[/b] Only impacts BehaviorTree driven entities. [br]
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var export_enable_random_patrol: bool = false
## Determines how often the component checks whether the entity should randomly enter an patrol state. [br]
## [b]Tip:[/b] Larger values make random patrol checks less frequent. [br]
## [b]Note:[/b] Setting to [code]0[/code] disables random patrol checks entirely.
@export_range(0, 5, 0.1, "suffix:s", "or_greater") var export_patrol_interval: float = 0
## Determines the percentage chance (0–100%) that the entity will decide to patrol each time a random check occurs. [br]
## [b]Note:[/b] Low values make random patrolling rare and natural; higher values increase frequency. [br]
@export_range(0, 100, 1, "suffix:%") var export_patrol_chance: float = 0

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
@export var idle_component: NodePath
@export var randomizer_component: NodePath
@export var movement_component: NodePath

@onready var actor: Node = get_node_or_null(actor_path)
@onready var idle_comp: Node = get_node_or_null(idle_component)
@onready var movement_comp: Node = get_node_or_null(movement_component)
@onready var randomizer_comp: Node = get_node_or_null(randomizer_component)

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
		"IdleState entered by: ", actor.name, "\n",
		"===========================")
	
	init_idle()

func init_idle() -> void:
	actor.animations.play(state_animation)
	enter_callback.call()
	
	if export_use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		idle_comp.start()
		bb["force_idle"] = false
		bb["locked"] = true

func process_physics(delta: float) -> State:
	actor.velocity.x = 0
	
	if export_use_behavior_tree:
		if export_enable_randomize_direction:
			var bb: Dictionary = actor.get_blackboard()
			var result : Dictionary = movement_comp.direction_randomizer("idle", export_swap_chance, export_swap_interval, delta)
			if result.success:
				bb["move_direction"] = result.direction

		if export_enable_random_patrol:
			var bb: Dictionary = actor.get_blackboard()
			var can_patrol : bool = randomizer_comp.randomizer("patrol", export_patrol_chance, export_patrol_interval, delta)
			if can_patrol:
				if enable_debug:
					print(actor.name, "IdleState: Random Patrol enabled & can patrol.")
				bb["force_patrol"] = true
				bb["locked"] = false
	
		if export_enable_random_jump:
			var bb: Dictionary = actor.get_blackboard()
			var can_jump : bool = randomizer_comp.randomizer("jump", export_jump_chance, export_jump_interval, delta)
			if can_jump:
				if enable_debug:
					print(actor.name, "IdleState: Random Jump enabled & can jump.")
				bb["force_jump"] = true
				bb["locked"] = false

	if use_parent_logic:
		return handle_physics.call(delta)

	return null

func process_frame(delta: float) -> State:
	if export_use_behavior_tree:
		var bb: Dictionary = actor.get_blackboard()
		idle_comp.update(delta)
		
		if not idle_comp.is_active:
			bb["has_collided"] = false
			bb["can_idle"] = true
			bb["can_jump"] = true
			bb["can_patrol"] = true
			bb["locked"] = false

	if use_parent_logic:
		return handle_frame.call(delta)

	return null

func process_input(event: InputEvent) -> State:
	return handle_input.call(event)
