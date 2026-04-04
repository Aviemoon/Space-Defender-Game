extends CanvasLayer

signal load_scene_started
signal new_scene_ready(target_name : String, offset : String)
signal load_scene_finished
signal scene_entered(uid : String)

#@onready var fade: Control

var current_scene_uid : String = 'uid://cugfsoo4pjghg'

func _ready() -> void:

	await get_tree().process_frame
	load_scene_finished.emit()
	

func transition_scene(new_scene:String, target_area:String = '', player_offset:Vector2 = Vector2.ZERO, dir:String = '') -> void:
	#if !fade:
		#fade = %Fade
	#fade.visible = false
	#var fade_pos:Vector2 = get_fade_position(dir)
	#fade.visible = true
	#await fade_screen(fade_pos, Vector2.ZERO)
	#
	load_scene_started.emit()
	await get_tree().process_frame
	await get_tree().process_frame
	
	get_tree().change_scene_to_file(new_scene)
	current_scene_uid = ResourceUID.path_to_uid(new_scene)
	print('new scene: ', current_scene_uid)
	scene_entered.emit(current_scene_uid)
	
	await get_tree().scene_changed
	
	
	
	new_scene_ready.emit(target_area, player_offset)
	#await GlobalSignal.load_animation
	#await fade_screen(Vector2.ZERO, -fade_pos)
	
	load_scene_finished.emit()
	
	if Global.room_count > 0:
		SavingManager.save_game()
		
	Global.objective_init()
#
#func fade_screen(from:Vector2, to:Vector2) -> Signal:
	#fade.position = from
	#var tween = create_tween()
	#tween.tween_property(fade, 'position', to, 0.2)
	#return tween.finished
	#

func get_fade_position(dir:String) -> Vector2:
	var pos:Vector2 = Vector2(2560, 1440)
	
	match dir:
		'left':
			pos.x *= -1
		'right':
			pos.x *= 1
		'up':
			pos.y *= -1
		'down':
			pos.y *= 1
	
	return pos
