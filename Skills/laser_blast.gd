extends BaseProjectile

var direction = Vector2.RIGHT
var die = 0

func _ready() -> void:
	calculate_stats()
	

func attack():
	rotate(get_angle_to(get_global_mouse_position()))
	GlobalSignal.player_ability_2.disconnect(attack)
	#if global_position.x > get_global_mouse_position().x:
		#direction = Vector2.LEFT
	#else:
		#direction = Vector2.RIGHT
	#rotate(get_angle_to(direction))

func _physics_process(delta: float) -> void:
	go_to_rotation(delta)



func _on_body_entered(body: Node2D) -> void:
	
	enemy_hit(1)



func _on_tree_entered() -> void:
	GlobalSignal.player_ability_2.connect(attack)


#func _on_tree_exited() -> void:
	#GlobalSignal.player_ability_2.disconnect(attack)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(3).timeout
	print('die')
	queue_free()
