extends BaseProjectile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.player_ground_slam.connect(attack)
	calculate_stats()
	reparent(get_tree().root)
	await get_tree().create_timer(0.1).timeout
	GlobalSignal.player_ground_slam.disconnect(attack)
	call_deferred('queue_free')

func attack(player):
	print('awa awa ground slaaammm!', player)

func _on_tree_entered() -> void:
	print('awa?')
