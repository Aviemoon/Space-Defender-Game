extends Control

var chosen_levels: Array = []
var chosen_names: Array = []
@onready var choice_1_label: Label = $Choice1/VBoxContainer/Choice1Label
@onready var choice_2_label: Label = $Choice2/VBoxContainer/Choice2Label


func transition(p_scene):
	SceneManager.transition_scene(p_scene, 'PlayerSpawn', Vector2.ZERO, '')

func set_levels(p_array):
	chosen_levels = [] # add all this to saving somehow...
	chosen_names = []# zozo go baboba
	await get_tree().physics_frame
	await get_tree().physics_frame
	for i in range(2):
		var rand_lvl: Array = Global.get_random_level_and_name()
		
		while rand_lvl[0] in chosen_levels or rand_lvl[0] == SceneManager.current_scene_uid:
			rand_lvl = Global.get_random_level_and_name()
		#print('rand %s' % rand_lvl)
		rand_lvl = Global.get_random_level_and_name()
		rand_lvl = Global.get_random_level_and_name()
		
		chosen_levels.append(rand_lvl[0])
		chosen_names.append(rand_lvl[1])
		
	#print('yay1 %s' % chosen_levels)
	#print('yay2 %s' % chosen_names)
	if chosen_names and chosen_levels:
		choice_1_label.text = chosen_names[0]
		choice_2_label.text = chosen_names[1]


func _on_choice_1_pressed() -> void:
	get_tree().paused = false
	transition(chosen_levels[0])

func _on_choice_2_pressed() -> void:
	get_tree().paused = false
	transition(chosen_levels[1])


func _on_tree_entered() -> void:
	GlobalSignal.portal_levels_chosen.connect(set_levels)


func _on_tree_exited() -> void:
	GlobalSignal.portal_levels_chosen.disconnect(set_levels)
