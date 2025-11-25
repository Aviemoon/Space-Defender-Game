extends BaseEnemy




func _on_hurtbox_hurt(p_friendly, p_damage, p_angle, p_knockback):
	hurt(p_friendly, p_damage, p_angle, p_knockback)
