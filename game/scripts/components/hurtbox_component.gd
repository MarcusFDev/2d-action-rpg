class_name HurtBoxComponent
extends Area2D

@export var owner_path: NodePath
@onready var hurtbox_owner: Node = get_node(owner_path)
