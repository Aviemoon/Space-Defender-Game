@tool
class_name LevelTransition extends Node2D

enum TRANSITION_SIDE {LEFT, RIGHT, TOP, BOTTOM}
@onready var area_2d: Area2D = $DoorArea2D

@export var location: TRANSITION_SIDE = TRANSITION_SIDE.LEFT:
	set(value):
		location = value
		apply_area_settings()

@export_range(2, 12, 1) var size: int = 2: 
	set(value):
		size = value
		apply_area_settings()

@export_file("*.tscn") var target_level: String = ''
@export var target_area: String  = 'LevelTransition'

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	SceneManager.new_scene_ready.connect(_on_new_scene_ready)
	SceneManager.load_scene_finished.connect(_on_load_scene_finished)
	pass
	

func _on_new_scene_ready(target_name:String, offset:Vector2) -> void:
	if target_name == name:
		var player:Node = get_tree().get_first_node_in_group('Player')
		player.global_position = global_position + offset
		print(player.global_position)
		print(global_position + offset)
	
	pass

func _on_load_scene_finished() -> void:
	area_2d.monitoring = false
	
	area_2d.body_entered.connect(_on_player_entered)
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	area_2d.monitoring = true
func _on_player_entered(p_player: Node2D) -> void:
	SceneManager.transition_scene(target_level, target_area, calculate_offset(p_player), '')
	

func calculate_offset(p_player:Node2D) -> Vector2:
	var offset:Vector2 = Vector2.ZERO
	var player_position = p_player.global_position
	if location == TRANSITION_SIDE.LEFT or location == TRANSITION_SIDE.RIGHT:
		#offset.y = player_position.y - global_position.y
		offset.y = global_position.y
		print("player pos: %d\nglobal pos: %d" % [player_position.y, global_position.y])
		if location == TRANSITION_SIDE.LEFT:
			offset.x = -8
		else:
			offset.x = 8
	else:
		offset.x = player_position.x - global_position.x
		if location == TRANSITION_SIDE.TOP:
			offset.y = 8
		else:
			offset.y = 24
	return offset

func apply_area_settings() -> void:
	print(location)
	area_2d = get_node_or_null("DoorArea2D")
	if !area_2d:
		return
	if location == TRANSITION_SIDE.LEFT or location == TRANSITION_SIDE.RIGHT:
		if location == TRANSITION_SIDE.LEFT:
			area_2d.scale.x = -1
		else: 
			area_2d.scale.x = 1
		area_2d.scale.y = size
	else: # top / bottom
		if location == TRANSITION_SIDE.TOP:
			area_2d.scale.y = 1
		else:
			area_2d.scale.y = -1
		area_2d.scale.x = size
