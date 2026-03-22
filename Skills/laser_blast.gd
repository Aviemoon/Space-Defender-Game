extends BaseProjectile

var direction = Vector2.RIGHT


func _ready() -> void:
	calculate_stats()
	

func attack():
	rotate(get_angle_to(get_global_mouse_position()))
	angle = Vector2.RIGHT.rotated(rotation)
	GlobalSignal.player_ability_2.disconnect(attack)

func _physics_process(delta: float) -> void:
	go_to_rotation(delta)



func _on_body_entered(body: Node2D) -> void:
	if not (body.is_in_group('Player')):
		if death_fx:
			death_effect(death_fx)
		enemy_hit(body, 1)



func _on_tree_entered() -> void:
	GlobalSignal.player_ability_2.connect(attack)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(3).timeout
	call_deferred('queue_free')
