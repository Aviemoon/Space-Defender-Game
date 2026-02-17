extends RigidBody2D

var hp = 1
@export var drops: Array[PackedScene]

func _on_hurtbox_hurt(p_friendly: Variant, p_damage: Variant, p_angle: Variant, p_knockback: Variant) -> void:
	hp -= p_damage
	if hp <= 0:
		for i in drops:
			var new_drop = i.instantiate()
			new_drop.global_position = global_position
			get_parent().call_deferred("add_child", new_drop)
		call_deferred('queue_free')
