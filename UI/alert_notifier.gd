extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('alert')
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'position:y', position.y + 12, 0.2)
	tween.tween_property(self, 'modulate:a', 0, 1)
	await tween.finished
	tween.kill()
	queue_free()
