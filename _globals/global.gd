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

func _ready() -> void:
	levels = load_directory(ROOM_DIR)
	items = load_directory(ITEM_DIR)
	skills = load_directory(SKILL_DIR)
	
	#print(levels)

func load_directory(source: String):
	var target: Array
	for file_name in DirAccess.get_files_at(source):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
			
		var scene_uid = ResourceUID.path_to_uid(ROOM_DIR + file_name)
		if file_name[0] != '_':
			target.append(scene_uid)
	
	return target

func get_random_level_and_name():
	var list: Array
	for file_name in DirAccess.get_files_at(ROOM_DIR):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
		var scene_uid = ResourceUID.path_to_uid(ROOM_DIR + file_name)
		if file_name[0] != '_':
			list.append([scene_uid, file_name])
		#print(file_name)
	
	
	var rand_lvl = list.pick_random()
	
	return rand_lvl
			
		
			
