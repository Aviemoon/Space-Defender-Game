extends BaseProjectile

func _ready():
	calculate_stats()
	$CollisionShape2D.disabled = false
	

func attack():
	if scale.x > 0:
		angle = Vector2.RIGHT
	else:
		angle = Vector2.LEFT
	$Sprite2D.visible = true

	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0, 0.1)
	await tween.finished
	tween.kill()
	$CollisionShape2D.disabled = true
	queue_free()


func _on_tree_entered():
	GlobalSignal.player_ability_1.connect(attack)


func _on_tree_exiting():
	GlobalSignal.player_ability_1.disconnect(attack)
