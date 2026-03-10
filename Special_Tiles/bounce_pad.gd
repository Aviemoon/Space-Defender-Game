extends RigidBody2D

func _on_interact_area_body_entered(body: Node2D) -> void:
	print(body)
	#if body.get('velocity'):
	body.velocity.y = 200
	print(body.velocity)
