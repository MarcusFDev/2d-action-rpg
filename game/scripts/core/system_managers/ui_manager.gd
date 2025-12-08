@icon("uid://nh84ga4kp4vf")
class_name UIManager
extends Node

## Enables debug messages in the output terminal. [br]
## [b]Note:[/b] Useful for development and troubleshooting.
@export var enable_debug: bool = false

@export_category("Manager Settings")

@export_group("Menu Paths")
@export var main_menu: MainMenu
@export var pause_menu: PauseMenu
@export var level_pick_menu: LevelPickMenu
@export var settings_menu: SettingsMenu
@export var credits_menu: CreditsMenu
@export var game_over_menu: GameOverMenu

#Script Variables
var ui_menus: Dictionary
var current_menu: String
var previous_menu: String

func _enter_tree() -> void:
	Global.ui_manager = self

func _ready() -> void:
	ui_menus = {
		"main_menu": main_menu,
		"pause_menu": pause_menu,
		"level_pick_menu": level_pick_menu,
		"settings_menu": settings_menu,
		"credits_menu": credits_menu,
		"game_over_menu": game_over_menu,
	}
	change_menu("main_menu")

func change_menu(path: String) -> void:
	if current_menu == path:
		ui_menus[path].hide()
		Engine.time_scale = 1
		previous_menu = current_menu
		current_menu = ""
		if enable_debug:
			print("UiManager | Toggled off Menu: ", path)
		return
	
	previous_menu = current_menu
	current_menu = path
	
	for menu: Control in ui_menus.values():
		menu.hide()
	
	ui_menus[path].show()
	Engine.time_scale = 0
	if enable_debug:
		print("UiManager | Menu changed to: ", path)

# ==============================
# ==== Menu Button Handling ====
# ==============================

func on_hide_menu() -> void:
	change_menu(current_menu)

func on_main_menu() -> void:
	change_menu("main_menu")

func on_pause_menu() -> void:
	change_menu("pause_menu")

func on_level_pick_menu() -> void:
	change_menu("level_pick_menu")

func on_settings_menu() -> void:
	change_menu("settings_menu")

func on_game_over_menu() -> void:
	change_menu("game_over_menu")

func on_credits_menu() -> void:
	change_menu("credits_menu")

func on_back_btn() -> void:
	change_menu(previous_menu)
