class_name Pickup extends RigidBody2D

#signal picked_up
var target = null
var speed = -0.25
@export var  speed_modifier: int = 5

func collect():
	$CollisionShape2D.call_deferred('set', 'disabled', true)
	visible = false
	
	await get_tree().create_timer(1).timeout
