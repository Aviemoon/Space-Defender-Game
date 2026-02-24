class_name Coin extends Pickup

@export var value: int = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



func _physics_process(delta: float) -> void:
	if target:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += speed_modifier

func collect():
	super.collect()
	return value
