extends Control

@onready var PauseUI = $PauseUI
@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var hp_label: Label = $MainUI/hpLabel
@onready var timer_label: Label = $MainUI/timerLabel
@onready var gold_label: Label = $MainUI/goldLabel
@onready var hurt_overlay: ColorRect = $Overlays/HurtOverlay
@onready var death_overlay: ColorRect = $Death/DeathOverlay
@onready var death: Control = $Death


#@export var hurt_overlay_curve: Curve

const HURT_ALPHA = 75

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
	timer_label.text = "Timer: %d:%02d" % [minutes, seconds]

func hurt_overlay_flash():
	print("YESSSSSSSSSSS")
	var tween = get_tree().create_tween()
	if tween.is_running():
		tween.stop()
		tween.play()
	hurt_overlay.modulate.a = 0.75
	print(hurt_overlay.modulate.a)
	hurt_overlay.visible = true
	
	tween.tween_property(hurt_overlay, 'modulate:a', 0, 0.75)
	await tween.finished
	tween.kill()
	hurt_overlay.visible = false

func pause_game():
	get_tree().paused = false
	PauseUI.visible = false

func update_labels():
	if Player is PlayerCharacter:
		hp_label.text = "Health: %d / %d" % [Player.hp, Player.max_hp]
		gold_label.text = "Gold: %d" % Player.gold

func player_die(player):
	
	$Death/Label.scale *= 0
	$Death/deathRestartButton.scale *= 0
	death.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(death_overlay, 'modulate:a', 0.3, 1)
	tween.set_parallel(true)
	tween.tween_property($Death/Label, 'scale', Vector2(1,1), 1)
	tween.tween_property($Death/deathRestartButton, 'scale', Vector2(1,1), 1)
	
	await tween.finished
	tween.kill()
	pause_game()
	GlobalSignal.player_finished_dying.emit()


func _on_button_pressed():
	pause_game()
	get_tree().reload_current_scene()


func _on_unpause_pressed():
	pause_game()



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


func _on_tree_entered() -> void:
	GlobalSignal.player_hurt.connect(hurt_overlay_flash)
	GlobalSignal.player_stat_change.connect(update_labels)
	GlobalSignal.player_die.connect(player_die)

func _on_tree_exited() -> void:
	GlobalSignal.player_hurt.disconnect(hurt_overlay_flash)
	GlobalSignal.player_stat_change.disconnect(update_labels)
	GlobalSignal.player_die.disconnect(player_die)


func _on_save_pressed() -> void:
	SavingManager.save_game()
	pause_game()


func _on_load_pressed() -> void:
	SavingManager.load_game()
	pause_game()


func _on_death_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
