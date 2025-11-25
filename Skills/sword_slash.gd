extends BaseProjectile

func _ready():
	calculate_stats()
	$CollisionShape2D.disabled = false
	

func attack():
	$Sprite2D.visible = true
	await get_tree().create_timer(0.06).timeout
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	queue_free()


func _on_tree_entered():
	GlobalSignal.player_ability_1.connect(attack)


func _on_tree_exiting():
	GlobalSignal.player_ability_1.disconnect(attack)
