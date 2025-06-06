extends Control
@onready var pause_menu: Control = $"."
@onready var level: Node2D = $"../../../../.."

var paused: bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		the_pause_menu()

func the_pause_menu() -> void:
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused


func _on_resume_btn_pressed() -> void:
	the_pause_menu()


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_restart_button_pressed() -> void:
	var current_scene: Node = get_tree().current_scene
	if current_scene:
		var scene_path: String = current_scene.scene_file_path
		# Unpause the game before restarting
		Engine.time_scale = 1
		paused = false
		get_tree().change_scene_to_file(scene_path)
