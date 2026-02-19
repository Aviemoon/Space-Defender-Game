class_name Interactable extends RigidBody2D


@export var action_name: String = ''
@export var drops: Array[PackedScene]

const EXPLOSION = preload("uid://dmctsbuquttft")



var player = null
var opened = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func create_explosion_effect(effect_scale = Vector2(1, 1), effect_offset = Vector2.ZERO) -> void:
	var explosion = EXPLOSION.instantiate()
	explosion.global_position = global_position + effect_offset
	explosion.scale = effect_scale
	
	get_parent().call_deferred("add_child", explosion)

func player_enter(body: Node2D) -> void:
	if body is PlayerCharacter: 
		player = body
		#GlobalSignal.player_enter_interact_area.emit(self)
	else:
		player = null

func player_exit() -> void:
	player = null
