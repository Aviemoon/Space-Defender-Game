class_name Coin extends Pickup

@export var value: int = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#func _ready() -> void:
	#var initial_y_position = animated_sprite_2d.position.y
	#var tween = get_tree().create_tween()
	#while true:
		#tween.tween_property(animated_sprite_2d, 'position:y', initial_y_position + 10, 2)
		#tween.tween_property(animated_sprite_2d, 'position:y', initial_y_position, 2)


#signal picked_up



func _physics_process(delta: float) -> void:
	if target:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += speed_modifier

func collect():
	super.collect()
	return value
