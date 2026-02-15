extends Area2D

signal hurt(p_friendly, p_damage, p_angle, p_knockback)
@export var friendly = false
@export_enum('HitOnce', 'Cooldown', 'Disable') var hurtbox_type = 0 

var hit_once_array:Array = []


func _on_area_entered(area):
	check_area(area)
	
func _on_body_entered(body: Node2D) -> void:
	check_body(body)


func check_body(body):
	if body is Spike and body.get('damage'):
		var damage = body.get('damage')
		var attacker_type = false
		
		hurt.emit(attacker_type, damage, 0, 0)


func check_area(area):
	if (area.is_in_group('attack_friendly') or area.is_in_group('attack_unfriendly')) and area.get('damage'):
		match hurtbox_type:
			0:
				
				if area not in hit_once_array:
					hit_once_array.append(area)
				else:
					return
			1:
				$CollisionShape2D.call_deferred('set', 'disabled', true)
				$disableTimer.start()
			2:
				pass
		var angle = Vector2.ZERO
		var knockback = 1
		var damage = area.get('damage')
		var attacker_type = ''
		if area.is_in_group('attack_friendly'):
			attacker_type = true
		else:
			attacker_type = false
		hurt.emit(attacker_type, damage, angle, knockback)



func _on_disable_timer_timeout() -> void:
	$CollisionShape2D.call_deferred('set', 'disabled', false)


func _on_area_exited(area: Area2D) -> void:
	if area in hit_once_array:
		hit_once_array.erase(area)
