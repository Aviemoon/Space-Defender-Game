extends Control

signal entered_options
signal left_options

func set_visibility():
	visible = true
	entered_options.emit()



func _on_options_back_pressed() -> void:
	visible = false
	left_options.emit()
