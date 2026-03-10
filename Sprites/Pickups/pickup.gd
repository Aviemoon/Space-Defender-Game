class_name Pickup extends RigidBody2D

#signal picked_up
var target = null
var speed = -0.25
@export var  speed_modifier: int = 1

#func _ready() -> void:
	#await get_tree().create_timer(2).timeout
	#set_collision_mask_value(3, true)

func collect():
	$CollisionShape2D.call_deferred('set', 'disabled', true)
	visible = false
	
	await get_tree().create_timer(1).timeout

func move_to_target():
	if target:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += speed_modifier

func item_collect():
	pass
