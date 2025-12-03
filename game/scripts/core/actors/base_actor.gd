class_name BaseActor
extends CharacterBody2D

## Assign the CharacterBody2D node this script belongs too.
@export var actor_path: NodePath
@export var actor_hurtbox: NodePath 
@export var actor_hitbox: NodePath
## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_group("Temporary Options")
@export var damage: int = 1

@export_group("State Paths")
@export var state_machine_path: NodePath
@export var idle_state_path: NodePath
@export var move_state_path: NodePath
@export var jump_state_path: NodePath
@export var fall_state_path: NodePath
@export var attack_state_path: NodePath
@export var heal_state_path: NodePath
@export var injured_state_path: NodePath
@export var death_state_path: NodePath

@export_group("Component Paths")
@export var gravity_component: NodePath 
@export var ground_check_component: NodePath 
@export var animation_component: NodePath
@export var edge_detector_component: NodePath
@export var jump_component: NodePath 
@export var idle_component: NodePath
@export var pickup_permission_component: NodePath 
@export var movement_component: NodePath 
@export var health_component: NodePath 
@export var randomizer_component: NodePath

# Actor Variables
@onready var actor: CharacterBody2D = get_node_or_null(actor_path)
@onready var hitbox: Area2D = get_node_or_null(actor_hitbox)
@onready var hurtbox: Area2D = get_node_or_null(actor_hurtbox)

# State Machine Variables
@onready var state_machine: Node = get_node_or_null(state_machine_path)
@onready var idle_state: Node = get_node_or_null(idle_state_path)
@onready var move_state: Node = get_node_or_null(move_state_path)
@onready var jump_state: Node = get_node_or_null(jump_state_path)
@onready var fall_state: Node = get_node_or_null(fall_state_path)
@onready var attack_state: Node = get_node_or_null(attack_state_path)
@onready var heal_state: Node = get_node_or_null(heal_state_path)
@onready var injured_state: Node = get_node_or_null(injured_state_path)
@onready var death_state: Node = get_node_or_null(death_state_path)

# Component Variables
@onready var gravity_comp: Node = get_node_or_null(gravity_component)
@onready var ground_check_comp: Node = get_node_or_null(ground_check_component)
@onready var animation_comp: Node = get_node_or_null(animation_component)
@onready var edge_detector_comp: Node = get_node_or_null(edge_detector_component)
@onready var jump_comp: Node = get_node_or_null(jump_component)
@onready var idle_comp: Node = get_node_or_null(idle_component)
@onready var pickup_permission_comp: Node = get_node_or_null(pickup_permission_component)
@onready var movement_comp: Node = get_node_or_null(movement_component)
@onready var health_comp: Node = get_node_or_null(health_component)
@onready var randomizer_comp: Node = get_node_or_null(randomizer_component)

# Script Variables
var animations: AnimatedSprite2D:
	get:
		return animation_comp.animations

# ===============================
# === Actor Helper Functions ====
# ===============================

func destroy_actor(signal_actor: Node) -> void:
	if signal_actor == actor:
		queue_free()
