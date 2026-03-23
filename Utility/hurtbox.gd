extends Area2D

signal hurt(p_friendly, p_damage, p_angle, p_knockback, p_attackerd)
@export var friendly = false
@export_enum('HitOnce', 'Cooldown', 'Disable') var hurtbox_type = 0 
@onready var disable_timer: Timer = $disableTimer

var hit_once_array: Array = []
var collision_in_hurtbox: Array = []

@export var hurt_area_cooldown: float = 0.5

func _on_area_entered(area):
	check_area(area)
	
func _on_body_entered(body: Node2D) -> void:
	check_body(body)


func check_body(body):
	if body is Spike and body.get('damage'):
		if body not in collision_in_hurtbox:
			collision_in_hurtbox.append(body)
		var damage = body.get('damage')
		var attacker_type = false
		#print('oww ow spike')
		hurt.emit(attacker_type, damage, 0, 0, body)
		await get_tree().create_timer(hurt_area_cooldown).timeout
		#print(collision_in_hurtbox)
		if body in collision_in_hurtbox:
			check_body(body)


func check_area(area):
	#print(collision_in_hurtbox)
	if ((area.is_in_group('attack_friendly') and not get_parent().is_in_group('Player')) or (area.is_in_group('attack_unfriendly'))) and area.get('damage'):
		if area not in collision_in_hurtbox:
			collision_in_hurtbox.append(area)
		match hurtbox_type:
			0:
				if area not in hit_once_array:
					hit_once_array.append(area)
				else:
					return
			1:
				$CollisionShape2D.call_deferred('set', 'disabled', true)
				disable_timer.start()
			2:
				pass
		var angle = Vector2.ZERO
		var knockback = 1
		var damage = area.get('damage')
		var attacker_type = ''
		if area.get('angle'):
			angle = area.angle
		if area.get('knockback'):
			knockback = area.knockback
		if area.is_in_group('attack_friendly'):
			attacker_type = true
		else:
			attacker_type = false
		hurt.emit(attacker_type, damage, angle, knockback, area)
		await get_tree().create_timer(hurt_area_cooldown).timeout
		if area in collision_in_hurtbox and area:
			#print(collision_in_hurtbox)
			check_area(area)



func _on_disable_timer_timeout() -> void:
	$CollisionShape2D.call_deferred('set', 'disabled', false)


func _on_area_exited(area: Area2D) -> void:
	if area in hit_once_array:
		hit_once_array.erase(area)
		collision_in_hurtbox.erase(area)


func _on_body_exited(body: Node2D) -> void:
	if body in collision_in_hurtbox:
		
		collision_in_hurtbox.erase(body)
