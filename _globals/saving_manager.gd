extends Node

var current_slot : int = 0

var save_data : Dictionary
var persistent_data : Dictionary = {}

const FILE_PATH = 'user://save.sav'
#const PLAYER = preload("uid://bn3p2gijv0tv2")





func _ready() -> void:
	pass


func create_new_save():
	var new_game_scene : String = ''
	save_data = {
		'scene_path' : new_game_scene,
		# player stats
		'location_x' : 0,
		'location_y' : 0,
		'acceleration' : 0.6,
		'deceleration' : 0.3,
		'jump_deceleration' : 0.5, 
		'skills' : ['uid://bmfx4t03bnc6f', 'uid://cq24cigt53s4x'], # sword slash, laser
		'hp' : 100,
		'max_hp' : 100,
		'gold' : 0,
		'defense' : 0,
		'speed' : 1750, 
		'jump_velocity' : 320,
		'fall_immunity' : false,
		'items' : []
	}
	var save_file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))

#func _unhandled_key_input(event: InputEvent) -> void:
	#if event is InputEventKey and event.pressed:
		#if event.keycode == KEY_F5:
			#save_game()
		#elif event.keycode == KEY_F7:
			#load_game()
	#pass

func save_game():
	var player : PlayerCharacter = get_tree().get_first_node_in_group('Player') # deal with this later for multiplayer stuff
	print(player)
	save_data = {
		'player' : player,
		'scene_path' : SceneManager.current_scene_uid,
		'location_x' : player.global_position.x,
		'location_y' : player.global_position.y,
		'acceleration' : player.acceleration,
		'deceleration' : player.deceleration,
		'jump_deceleration' : player.jump_deceleration, 
		'skills' : player.skills,
		'hp' : player.hp,
		'max_hp' : player.max_hp,
		'gold' : player.gold,
		'defense' : player.defense,
		'speed' : player.speed, 
		'jump_velocity' : player.jump_velocity,
		'fall_immunity' : player.fall_immunity,
		'items' : player.items
	}
	
	var save_file = FileAccess.open(FILE_PATH , FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	GlobalSignal.save_game.emit()

func load_game():
	if !FileAccess.file_exists(FILE_PATH):
		print('???')
		return
	
	var save_file = FileAccess.open(FILE_PATH, FileAccess.READ)
	save_data = JSON.parse_string(save_file.get_line())
	persistent_data = save_data.get("persistent_data", {})
	var scene_path = save_data.get('scene_path', 'uid://cugfsoo4pjghg')
	print('scenepath:  ', SceneManager.current_scene_uid)
	SceneManager.transition_scene(scene_path, '', Vector2.ZERO, 'up')
	await SceneManager.load_scene_finished
	load_player()

func load_player():
	#var player = save_data.get('player')
	var player = get_tree().get_first_node_in_group('Player')
	#print(player)
	#print(Vector2(save_data.get('location_x', 0), save_data.get('location_y', 0)))
	#if not player:
		#spawn_player()
		#print('aaa')
		#player = get_tree().get_first_node_in_group('Player') # deal with this later for multiplayer stuff
	player.global_position = Vector2(save_data.get('location_x', 0), save_data.get('location_y', 0))
	player.gold = save_data.get('gold', 0)
	player.max_hp = save_data.get('max_hp', 100)
	player.hp = save_data.get('hp', 100)

#func spawn_player():
	#var player = PLAYER.instantiate()
	#get_tree().root.call_deferred('add_child', player)
