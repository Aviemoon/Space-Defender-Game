extends Interactable

var hp = 1

func _ready() -> void:
	position.y += 1


func _on_hurtbox_hurt(p_friendly: Variant, p_damage: Variant, p_angle: Variant, p_knockback: Variant) -> void:
	hp -= p_damage
	if hp <= 0:
		for i in drops:
			var new_drop = i.instantiate()
			new_drop.global_position = global_position
			get_parent().call_deferred("add_child", new_drop)
		create_explosion_effect(Vector2(0.5, 0.5))
		call_deferred('queue_free')


func _on_body_entered(body: Node) -> void:
	print('awaaw is body a')
