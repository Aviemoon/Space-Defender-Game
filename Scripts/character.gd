extends CharacterBody2D
class_name Character

@export var friendly = false
@export var skills:Array[PackedScene]
@export var max_hp = 0
@onready var hp = max_hp
@export var damage = 0
@export var defense = 0

@export var speed = 233.0
@export var jump_velocity = 312.0
@export var fall_immunity:bool = false


var hp_lbl = Label.new()

func _ready():
	hp_lbl.global_position = global_position
	hp_lbl.position.y -= 10
	hp_lbl.add_theme_font_size_override('font_size', 8)
	hp_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(hp_lbl)

func create_dmg_num(num:int):
	#var ctrl = Control.new()
	var lbl = Label.new()
	#lbl.scale = Vector2.ZERO
	lbl.add_theme_color_override('font_shadow_color', Color.BLACK)
	lbl.add_theme_constant_override('shadow_offset_x', 2)
	lbl.add_theme_constant_override('shadow_offset_y', 2)
	lbl.add_theme_font_size_override('font_size', 8)
	lbl.text = str(num)
	lbl.global_position = global_position
	lbl.scale = scale 
	
	
	#get_parent().add_child(ctrl)
	get_parent().add_child(lbl)
	#GlobalVar.current_labels += 1
	var tween = get_tree().create_tween()
	tween.tween_property(lbl, 'global_position:y',  lbl.global_position.y - 25, 0.1)
	tween.set_parallel()
	#tween.tween_property(lbl, 'scale:y', 1, 1)
	
	tween.tween_property(lbl, 'modulate:a', 0, 0.30).set_delay(0.25)
	
	await tween.finished
	tween.kill()
	lbl.call_deferred('queue_free')

func hurt(p_friendly, p_damage, p_angle, p_knockback):
	if p_friendly != friendly:
		hp_lbl.text = str(hp)
		#print('%s, %s, %s, %s' % [p_friendly, p_damage, p_angle, p_knockback])
		var total_dmg = p_damage
		if total_dmg > 0:
			hp -= total_dmg - defense/2
			print('hp is %s' % hp)
			create_dmg_num(total_dmg)
			if hp <= 0:
				die()



func die():
	queue_free()
