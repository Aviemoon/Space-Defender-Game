extends BaseProjectile

var direction = Vector2.RIGHT
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	calculate_stats()
	attack()
	print(rotation)

func attack():
	pass
	#rotate(get_angle_to(Vector2.RIGHT.rotated(direction)))



func _physics_process(delta: float) -> void:
	go_to_rotation(delta)


func _on_body_entered(body: Node2D) -> void:
	
	death_effect($AnimatedSprite2D)
	enemy_hit(body, 1)
	#queue_free()
