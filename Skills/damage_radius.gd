extends BaseProjectile

@export var duration: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	calculate_stats()
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, 'modulate:a', 0, duration)
	await tween.finished
	tween.kill()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
