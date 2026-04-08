extends Node2D

@onready var spawn_totem: Node2D = $Tiles/Other/SpawnTotem
@onready var label_4: Label = $Labels/Control/Label4
@onready var wall: StaticBody2D = $Tiles/wall
@onready var label_5: Label = $Labels/Control/Label5
@onready var wall_2: StaticBody2D = $Tiles/wall2

var enemies_dead = 0
var enemies_needed = 5

func _ready() -> void:
	GlobalSignal.enemy_die.connect(check_door_enemy)

func check_door_enemy(_en, _a):
	print('check cehck check')
	enemies_dead += 1
	label_4.text = 'Kill %d / %d enemies' % [enemies_dead, enemies_needed]
	if enemies_dead >= enemies_needed:
		spawn_totem.locked = true
		wall.queue_free()
		label_5.visible = true


func _on_totem_trigger_body_entered(_body: Node2D) -> void:
	spawn_totem.locked = false
	print(spawn_totem.locked)


func _on_interact_handler_interact() -> void:
	SceneManager.transition_main_menu()


func _on_hurtbox_hurt(p_friendly: Variant, p_damage: Variant, p_angle: Variant, p_knockback: Variant, p_attackerd: Variant) -> void:
	wall_2.queue_free()
	$Labels/Control/Label7.visible = false
