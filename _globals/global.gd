extends Node

var levels: Array
var items: Array
var skills: Array

var difficulty_modifier = 1

const ROOM_DIR = "res://rooms/"
const ITEM_DIR = "res://items/"
const SKILL_DIR = "res://Skills/"

var enemy_limit = 50
var enemies_alive = 0

var room_count = 0

const _EXTERMINATE = 'exterminate'
const _SURVIVE = 'survive'

var objective_exterminate_killed: int = 0
var objective_exterminate_needed: int = 50

var survive_time_passed: float = 0
var survive_time_needed: float = 60

var objective_types: Array = [_EXTERMINATE, _SURVIVE] 
var current_objective

var completed = false

signal objective_title(name)
signal objective_complete

var sfx_num = 0

func objective_init():
	room_count += 1
	purge_objective_values()
	
	if room_count % 3 != 0:
		choose_objective()
	
func _process(delta: float) -> void:
	if current_objective == _SURVIVE and ! get_tree().paused:
		survive_time_passed += delta
		check_objective()

func purge_objective_values():
	objective_exterminate_killed = 0
	survive_time_passed = 0
	completed = false

func _kill_increment() -> void:
	objective_exterminate_killed += 1

func choose_title():
	
	var title = ''
	
	match current_objective:
		_EXTERMINATE:
			
			title = 'Kill %d / %d enemies' % [objective_exterminate_killed, objective_exterminate_needed]
		_SURVIVE:
			title = 'survive for %d / %d seconds' % [survive_time_passed, survive_time_needed]
	objective_title.emit(title)

func check_objective(idk = ''):
	_kill_increment()
	choose_title()
	if completed:
		return
	match current_objective:
		_EXTERMINATE:
			if objective_exterminate_killed >= objective_exterminate_needed:
				objective_complete.emit()
				completed = true
		_SURVIVE:
			if survive_time_passed >= survive_time_needed:
				objective_complete.emit()
				completed = true
	

func choose_objective(p_objective = null):
	if not p_objective:
		current_objective = objective_types.pick_random()
	else:
		current_objective = p_objective
	choose_title()

func _ready() -> void:
	GlobalSignal.enemy_die.connect(check_objective)
	#GlobalSignal.enemy_die.connect(_kill_increment)
	SceneManager.load_scene_finished.connect(purge_objective_values)
	
	levels = load_directory(ROOM_DIR)
	items = load_directory(ITEM_DIR)
	skills = load_directory(SKILL_DIR)
	#await get_tree().create_timer(10).timeout
	#difficulty_modifier = 10
	#print(levels)

func load_directory(source: String):
	var target: Array
	for file_name in DirAccess.get_files_at(source):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
		if (file_name.get_extension() == "remap"):
			file_name = file_name.replace('.remap', '')
		
		#if '.tres.remap' in file_name or '.tscn.remap' in file_name: # <---- NEW
			#print('whoop whopp!!!')
			#print(file_name)
			#file_name = file_name.trim_suffix('.remap') # <---- NEW
			#print(file_name)
		var scene_uid = ResourceUID.path_to_uid(ROOM_DIR + file_name)
		if file_name[0] != '_':
			target.append(scene_uid)
	
	return target

func get_random_level_and_name():
	var list: Array
	for file_name in DirAccess.get_files_at(ROOM_DIR):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
		if (file_name.get_extension() == "remap"):
			file_name = file_name.replace('.remap', '')
		var scene_uid = ResourceUID.path_to_uid(ROOM_DIR + file_name)
		if file_name[0] != '_':
			list.append([scene_uid, file_name])
		#print(file_name)
	
	
	var rand_lvl = list.pick_random()
	
	return rand_lvl
			
		
			
