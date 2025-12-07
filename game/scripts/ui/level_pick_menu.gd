class_name LevelPickMenu
extends Control

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Menu Settings")
## Assign Level Button Container in scene tree.
@export var level_button_container: NodePath

@onready var level_container: Node = get_node_or_null(level_button_container)

func _ready() -> void:
	level_pick_menu()

func level_pick_menu() -> void:
	if level_button_container == null:
		if enable_debug:
			print("LevelPickMenu | Level Button Container not assigned.")
		return

	for button: Node in level_container.get_children():
		var btn_node: Node = button
		var dim_overlay: Node = btn_node.get_node_or_null("DimOverlay")
		var lock_icon: Node = btn_node.get_node_or_null("LockIcon")

		if dim_overlay and lock_icon:
			var is_locked: bool = true
			dim_overlay.visible = is_locked
			lock_icon.visible = is_locked

func on_back_btn() -> void:
	GameManager.on_back_btn()
	if enable_debug:
		print("LevelPickMenu | Back button press detected.")

func on_developer_level_btn() -> void:
	Engine.time_scale = 1
	GameManager.change_scene("res://scenes/levels/developer_level.tscn")
	if enable_debug:
		print("LevelPickMenu | DeveloperLevel button press detected.")

func on_level_1_btn() -> void:
	Engine.time_scale = 1
	GameManager.change_scene("res://scenes/levels/tutorial_level.tscn")
	if enable_debug:
		print("LevelPickMenu | Level1 button press detected.")
