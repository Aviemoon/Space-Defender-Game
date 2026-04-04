class_name Character extends CharacterBody2D

@export var friendly : bool = false
@export var skills : Array[PackedScene]
@export var items : Array[PackedScene]

@export_group('Stats', '')

@export var max_hp : float = 100

@export var defense = 0

@export var speed : float = 233.0
@export var jump_velocity = 312.0
@export var fall_immunity:bool = false
@export var knockback_immunity: bool = false

@export var weapon_damage_bonus : float = 0
@export var weapon_speed_bonus: float = 0
@export var weapon_knockback_bonus: float = 0
@export var weapon_hp_bonus: float = 0

@onready var hp : float = max_hp
var hp_lbl = Label.new()

var knockback: Vector2


func _ready():
	z_index = 7
	hp_lbl.global_position = global_position
	hp_lbl.position.y += 10
	hp_lbl.add_theme_font_size_override('font_size', 8)
	hp_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(hp_lbl)
	hp = max_hp

func create_dmg_num(num:int, color_override:String = "#ffffff", text_override:String = ""):
	#var ctrl = Control.new()
	var lbl = Label.new()
	#lbl.scale = Vector2.ZERO
	if color_override:
		lbl.add_theme_color_override('font_color', color_override)
	
	lbl.add_theme_color_override('font_shadow_color', Color.BLACK)
	lbl.add_theme_constant_override('shadow_offset_x', 2)
	lbl.add_theme_constant_override('shadow_offset_y', 2)
	lbl.add_theme_font_size_override('font_size', 16)
	if text_override:
		lbl.text = str(text_override)
	else:
		lbl.text = str(num)
	lbl.global_position = global_position
	lbl.scale = Vector2(.5, .5)
	
	

	get_parent().add_child(lbl)

	var tween = get_tree().create_tween()
	tween.tween_property(lbl, 'global_position:y',  lbl.global_position.y - 25, 0.1)
	tween.set_parallel()
	#tween.tween_property(lbl, 'scale:y', 1, 1)
	
	tween.tween_property(lbl, 'modulate:a', 0, 0.30).set_delay(0.25)
	
	await tween.finished
	tween.kill()
	lbl.call_deferred('queue_free')

func hurt(p_friendly, p_damage, p_angle, p_knockback, attacker = 0):
	if p_friendly != friendly:
		hp_lbl.text = str(hp)
		var total_dmg = p_damage - defense/2
		if total_dmg < 1:
			total_dmg = 1
		if ! knockback_immunity:
			knockback = p_knockback * Vector2(p_angle.x, 0)
			
		if total_dmg > 0:
			hp -= total_dmg 
			#print('hp is %s' % hp)
			create_dmg_num(total_dmg)
			
			if hp <= 0:
				die()
	#return true



func die():
	queue_free()
