extends Area2D

signal hurt(p_friendly, p_damage, p_angle, p_knockback)
@export var friendly = false



func _on_area_entered(area):

	if (area.is_in_group('attack_friendly') or area.is_in_group('attack_unfriendly')) and area.get('damage'):
		var angle = Vector2.ZERO
		var knockback = 1
		var damage = area.damage
		var attacker_type = ''
		if area.is_in_group('attack_friendly'):
			attacker_type = true
		else:
			attacker_type = false
		
		hurt.emit(attacker_type, damage, angle, knockback)
