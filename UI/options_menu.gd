extends Control

signal entered_options
signal left_options
@onready var mute: CheckBox = $TabContainer/Audio/MarginContainer/AudioBtns/Mute

var volume = 0.5

func set_visibility():
	visible = true
	entered_options.emit()



func _on_options_back_pressed() -> void:
	visible = false
	left_options.emit()


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	volume = value


#func _on_mute_pressed() -> void:
	#if mute.toggle_mode:
		#AudioServer.set_bus_volume_db(0, linear_to_db(0))
	#else:
		#AudioServer.set_bus_volume_db(0, linear_to_db(volume))
	#
