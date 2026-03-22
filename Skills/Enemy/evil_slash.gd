extends BaseProjectile
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready():
	calculate_stats()
	collision_shape_2d.disabled = false
	attack()

func attack():
	sprite_2d.visible = true
	#print('parent is %s' % get_parent())
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "modulate:a", 0, 0.1)
	await tween.finished
	tween.kill()
	collision_shape_2d.disabled = true
	queue_free()
