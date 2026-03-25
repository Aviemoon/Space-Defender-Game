extends Control

@onready var PauseUI = $PauseUI
@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var hp_label: Label = $MainUI/hpLabel
@onready var timer_label: Label = $MainUI/timerLabel
@onready var gold_label: Label = $MainUI/goldLabel
@onready var autosave_label: Label = $MainUI/AutosaveLabel

@onready var hurt_overlay: ColorRect = $Overlays/HurtOverlay
@onready var load_color_rect: ColorRect = $Overlays/LoadColorRect
@onready var death_overlay: ColorRect = $Death/DeathOverlay
@onready var death: Control = $Death

@onready var options_menu: Control = $PauseUI/OptionsMenu
@onready var level_select: Control = $LevelSelect

@onready var objective_name: Label = $Overlays/ObjectiveVbox/ObjectiveName

@onready var damage_lbl: Label = $Overlays/Stats/Damage

#@export var hurt_overlay_curve: Curve

const HURT_ALPHA = 75

var seconds = 0
var minutes = 0

var is_in_options:bool = false



func _process(delta):
	
	if Player:
		damage_lbl.text = "damage = %s" % Player.get("weapon_damage_bonus")
	# -- pausing --
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused and not is_in_options:
			get_tree().paused = false
			PauseUI.visible = false
		elif get_tree().paused and is_in_options:
			is_in_options = false
			$PauseUI/OptionsMenu.visible = false
			$PauseUI/MenuUi.visible = true
		elif level_select.visible:
			level_select_visibility()
			get_tree().paused = true
		
		else:
			get_tree().paused = true
			PauseUI.visible = true
	
	# -- timer --
	if not get_tree().paused:
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

func update_labels(playa):
	if playa is PlayerCharacter:
		hp_label.text = "Health: %d / %d" % [playa.hp, playa.max_hp]
		gold_label.text = "Gold: %d" % playa.gold

func autosave_animation():
	print('autooo')
	autosave_label.visible = true
	var t = get_tree().create_tween()
	for i in range(3):
		t.tween_property(autosave_label, 'modulate:a', 0.5, 0.3)
		t.tween_property(autosave_label, 'modulate:a', 1, 0.3)
	t.tween_property(autosave_label, 'modulate:a', 0, 0.35)
	await t.finished
	t.kill()
	autosave_label.visible = true
	
func player_die(player):
	await get_tree().physics_frame
	get_tree().paused = true
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

func level_select_visibility():
	level_select.visible = not level_select.visible
	if level_select.visible:
		get_tree().paused = true

func hide_lvl_select():
	level_select.visible = false

func load_anim():
	var tween = get_tree().create_tween()
	tween.tween_property(load_color_rect, 'self_modulate:a', 1, 1)
	GlobalSignal.load_animation.emit()
	tween.tween_property(load_color_rect, 'self_modulate:a', 0, 1)
	await tween.finished
	tween.kill()

func change_objective_title(p_name):
	objective_name.text = p_name
	
func done():
	objective_name.self_modulate.b = 0
	objective_name.text = 'complete'
	
func _on_tree_entered() -> void:
	GlobalSignal.player_hurt.connect(hurt_overlay_flash)
	GlobalSignal.player_stat_change.connect(update_labels)
	GlobalSignal.player_die.connect(player_die)
	GlobalSignal.portal_interacted_with.connect(level_select_visibility)
	SceneManager.load_scene_finished.connect(hide_lvl_select)
	#SceneManager.load_scene_finished.connect(load_anim)
	GlobalSignal.save_game.connect(autosave_animation)
	Global.objective_title.connect(change_objective_title)
	Global.objective_complete.connect(done)
	#GlobalSignal.enemy_die.connect(change_objective_title)

func _on_tree_exited() -> void:
	GlobalSignal.player_hurt.disconnect(hurt_overlay_flash)
	GlobalSignal.player_stat_change.disconnect(update_labels)
	GlobalSignal.player_die.disconnect(player_die)
	GlobalSignal.portal_interacted_with.disconnect(level_select_visibility)
	SceneManager.load_scene_finished.disconnect(hide_lvl_select)
	#SceneManager.load_scene_finished.disconnect(load_anim)
	GlobalSignal.save_game.disconnect(autosave_animation)
	Global.objective_title.disconnect(change_objective_title)
	Global.objective_complete.disconnect(done)


func _on_button_pressed():
	pause_game()
	get_tree().reload_current_scene()


func _on_unpause_pressed():
	pause_game()



func _on_quit_menu_pressed():
	get_parent().get_parent().queue_free()
	get_tree().paused = false
	SceneManager.transition_scene('uid://c4y786io00jka', '', Vector2.ZERO, '') # add continue with/without saving here
	#SceneManager.transition_scene()



func _on_quit_desktop_pressed(): # add continue with/without saving here
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



func _on_save_pressed() -> void:
	SavingManager.save_game()
	pause_game()


func _on_load_pressed() -> void:
	SavingManager.load_game()
	pause_game()


func _on_death_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_options_menu_left_options() -> void:
	is_in_options = false
	$PauseUI/OptionsMenu.visible = false
	$PauseUI/MenuUi.visible = true
