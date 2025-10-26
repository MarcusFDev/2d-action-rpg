class_name FallState
extends State

## Determines the animation that plays during the Fall State.[br]
## [b]Note:[/b] Must match an animation name in  [code]AnimatedSprite2D[/code]  or  [code]AnimationPlayer[/code].
@export var fall_animation : String
@export var use_behavior_tree: bool = false
## Determines whether this state uses parent-defined callbacks.[br]
## [b]Note:[/b] If set to [code]false[/code], all parent logic settings are ignored.
@export var use_parent_logic: bool = false
## Determines whether the entity's animation flips horizontally while moving using  [code]flip_h[/code].[br]
## [b]Note:[/b] Useful to set  [code]false[/code]  for symmetric & direction-agnostic entities.
@export var use_direction_flip: bool = false
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@onready var gravity_component: Node = $"../../Components/GravityComponent"
@onready var flip_component: Node = $"../../Components/DirectionFlipComponent"

# Script Variables
var direction: int = 1

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
	init_fall()

func init_fall() -> void:
	animations.play(fall_animation)
	enter_callback.call()
	
	if enable_debug:
		print(
			"\n===== Fall State: ===== \n", parent,
			"\nAnimation playing:", fall_animation)

func process_physics(_delta: float) -> State:
	if use_direction_flip:
		flip_component.apply(_delta)

		if enable_debug:
			print("Directional flip enabled. Animation flipped.", direction)

	if use_behavior_tree:
		gravity_component.apply(_delta)
		if parent.has_method("get_blackboard"):
			var bb: Variant = parent.get_blackboard()
			if bb:
				bb["is_grounded"] = parent.is_on_floor()
				if parent.is_on_floor():
					if enable_debug:
						print("FallState: Grounded, behavior tree will handle intent change.")

	if use_parent_logic:
		return handle_physics.call(_delta)

	return null

func exit() -> void:
	if enable_debug:
		print("Exiting FallState.")
