extends Control

var previous_menu: Control = null

func show_with_return(return_to: Control) -> void:
	previous_menu = return_to
	show()
	return_to.hide()

func _on_back_btn_pressed() -> void:
	hide()
	if previous_menu:
		previous_menu.show()
