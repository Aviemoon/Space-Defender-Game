extends BaseEnemy

var target = null
var can_turn: bool = true

@export var projectile: PackedScene
@onready var attack_timer: Timer = $AttackTimer

signal player_spotted


func _on_hurtbox_hurt(p_friendly, p_damage, p_angle, p_knockback, p_attacker):
	hurt(p_friendly, p_damage, p_angle, p_knockback, p_attacker)


func _on_turn_timer_timeout() -> void:
	if can_turn:
		#print(scale)
		scale.x *= -1


func attack():
	#print(scale.x)
	sprite.play('fire')
	var proj: BaseProjectile = projectile.instantiate()
	proj.global_position =  global_position
	if scale.y > 0:
		proj.rotation = deg_to_rad(180)
	else:
		proj.rotation = deg_to_rad(0)
	get_tree().root.call_deferred('add_child', proj)

func _on_field_of_view_body_entered(body: Node2D) -> void:
	target = body
	can_turn = false
	#print('player in view')
	player_spotted.emit()


func _on_field_of_view_body_exited(body: Node2D) -> void:
	target = null
	can_turn = true
	
	#print('player  not in view no more')
	#if not attack_timer.is_stopped():
	await attack_timer.timeout
	attack_timer.stop()
	await get_tree().create_timer(.3).timeout
	sprite.play('idle')


func _on_player_spotted() -> void:
	#print('player spotteddd!!!')
	var new_alert = ALERT.instantiate()
	new_alert.global_position =  global_position
	get_tree().root.add_child(new_alert)
	attack_timer.start()



func _on_attack_timer_timeout() -> void:
	attack()
