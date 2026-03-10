extends BaseProjectile

var dir = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	calculate_stats()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
