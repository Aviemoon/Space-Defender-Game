class_name Interactable extends RigidBody2D


@export var action_name: String = ''
@export var drops: Array[Drops]

var _action_lbl: Label

const EXPLOSION = preload("uid://dmctsbuquttft")



var player: PlayerCharacter = null
var opened = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func die():
	pass

func create_explosion_effect(effect_scale = Vector2(1, 1), effect_offset = Vector2.ZERO) -> void:
	var explosion = EXPLOSION.instantiate()
	explosion.global_position = global_position + effect_offset
	explosion.scale = effect_scale
	
	get_parent().call_deferred("add_child", explosion)

func create_action_label(x_offset = 0, y_offset = 0):
	var lbl_scale = 0.33
	_action_lbl = Label.new()
	_action_lbl.global_position = global_position
	_action_lbl.position = Vector2(x_offset, y_offset)
	_action_lbl.text = action_name
	_action_lbl.add_theme_color_override('font_color', '#ffffff')
	_action_lbl.add_theme_color_override('font_shadow_color', Color.BLACK)
	_action_lbl.add_theme_constant_override('shadow_offset_x', 2)
	_action_lbl.add_theme_constant_override('shadow_offset_y', 2)
	_action_lbl.add_theme_font_size_override('font_size', 16)
	_action_lbl.scale = Vector2(lbl_scale, lbl_scale)
	add_child(_action_lbl)

func destroy_action_label():
	if _action_lbl:
		_action_lbl.call_deferred('queue_free')

func player_enter(body: Node2D) -> void:
	if body is PlayerCharacter: 
		player = body
	else:
		player = null

func player_exit() -> void:
	player = null
	#print('exit!')
