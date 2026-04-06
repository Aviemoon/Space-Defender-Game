extends Interactable

@export_file("*.tscn") var target_levels: Array[String] = []
#@export_file("*.tscn") var target_level: String = ''
@export var target_area: String  = 'PlayerSpawn'


@onready var effect: Sprite2D = $Effect
@onready var interact_area: Area2D = $InteractHandler/InteractArea
const ROTATION_SPEED = 5
@export var locked = true
var spawn_point 

var levels = []

signal unlock # this will be emitted when the mission objective is finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !locked:
		turn_on()
	SceneManager.load_scene_finished.connect(_on_load_scene_finished)
	SceneManager.new_scene_ready.connect(_on_new_scene_ready)
	pick_levels(2)


func pick_levels(num = 2):
	if not target_levels:
		for i in range(num):
			levels.append(Global.levels.pick_random())
		GlobalSignal.portal_levels_chosen.emit(levels)
	else:
		for i in range(num):
			levels.append(target_levels.pick_random())

func _on_load_scene_finished() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame

func _physics_process(delta: float) -> void:
	effect.rotation_degrees += ROTATION_SPEED * delta

func _on_new_scene_ready(target_name:String, offset:Vector2) -> void:
	if not target_name:
		return
	
	var players: Array = get_tree().get_nodes_in_group('Player')
	#var p: PlayerCharacter = get_tree().get_first_node_in_group('Player')
	for i in players:
		i.global_position = offset
	print('everything just went right!')

func interact():
	if !target_area:
		pass
	GlobalSignal.portal_interacted_with.emit()
	#SceneManager.transition_scene(target_level, target_area, Vector2.ZERO, '')

func turn_on():
	locked = false
	effect.visible = true
	$OpenSFX.play()
	$InteractHandler.can_show = true
	Global.objective_complete.disconnect(turn_on)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player and not locked:
		interact()
		$InteractHandler.interact.emit()

func _on_interact_area_body_entered(body: Node2D) -> void:
	player_enter(body)


func _on_interact_area_body_exited(body: Node2D) -> void:
	player_exit()


func _on_tree_entered() -> void:
	Global.objective_complete.connect(turn_on)


func _on_tree_exited() -> void:
	if Global.objective_complete.is_connected(turn_on):
		Global.objective_complete.disconnect(turn_on)
