extends Control

@onready var PauseUI = $PauseUI
@onready var Player = get_tree().get_first_node_in_group("Player")

var seconds = 0
var minutes = 0

var is_in_options:bool = false


func _process(delta):
	# -- pausing --
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused and not is_in_options:
			get_tree().paused = false
			PauseUI.visible = false
		elif get_tree().paused and is_in_options:
			is_in_options = false
			$PauseUI/OptionsMenu.visible = false
			$PauseUI/MenuUi.visible = true
		else:
			get_tree().paused = true
			PauseUI.visible = true
	
	# -- timer --
	seconds += delta
	if seconds > 60:
		seconds -= 60
		minutes += 1
	$MainUI/timerLabel.text = "Timer: %d:%02d" % [minutes, seconds]
	
	# -- hp --
	if Player:
		$MainUI/hpLabel.text = "Health: %d / %d" % [Player.hp, Player.max_hp]


func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_unpause_pressed():
	get_tree().paused = false
	PauseUI.visible = false



func _on_quit_menu_pressed():
	pass


func _on_quit_desktop_pressed():
	get_tree().quit()


func _on_options_pressed():
	is_in_options = true
	$PauseUI/OptionsMenu.visible = true
	$PauseUI/MenuUi.visible = false


func _on_options_back_pressed():
	is_in_options = false
	$PauseUI/OptionsMenu.visible = false
	$PauseUI/MenuUi.visible = true


func _on_viewport_resolution_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
