extends Interactable

@export_file("*.tscn") var target_level: String = ''
@export var target_area: String  = 'PlayerSpawn'


@onready var effect: Sprite2D = $Effect
@onready var interact_area: Area2D = $InteractHandler/InteractArea
const ROTATION_SPEED = 5
var locked = false
var spawn_point 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.load_scene_finished.connect(_on_load_scene_finished)
	SceneManager.new_scene_ready.connect(_on_new_scene_ready)

func _on_load_scene_finished() -> void:
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	

func _physics_process(delta: float) -> void:
	effect.rotation_degrees += ROTATION_SPEED * delta

func _on_new_scene_ready(target_name:String, offset:Vector2) -> void:
	if target_name:
		var players: Array = get_tree().get_nodes_in_group('Player')
		var p: PlayerCharacter = get_tree().get_first_node_in_group('Player')
		print(target_name)
		for i in players:
			i.global_position = offset
		#print(players.global_position)
		#print(global_position + offset)
	
func interact():
	if !target_area:
		pass
	print('intero')
	
	SceneManager.transition_scene(target_level, target_area, Vector2.ZERO, '')
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player and not locked:
		interact()
		$InteractHandler.interact.emit()

func _on_interact_area_body_entered(body: Node2D) -> void:

	
	player_enter(body)


func _on_interact_area_body_exited(body: Node2D) -> void:
	player_exit()
