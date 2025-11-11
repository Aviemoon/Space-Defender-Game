extends Control

@onready var PauseUI = $PauseUI

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			PauseUI.visible = false
		else:
			get_tree().paused = true
			PauseUI.visible = true


func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
