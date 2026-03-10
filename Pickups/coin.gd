class_name Coin extends Pickup

@export var value: int = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_pickup: AudioStreamPlayer2D = $SFXPickup



func _physics_process(delta: float) -> void:
	move_to_target()

func collect():
	super.collect()
	sfx_pickup.play()
	return value
