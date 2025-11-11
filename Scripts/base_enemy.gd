extends Character
class_name BaseEnemy

@export_enum("sentry", "wonder", "custom") var AI_type = "sentry"
@export var can_fly:bool = false

var direction:Vector2
@onready var player = get_tree().get_first_node_in_group("player")
@export var sprite:Sprite2D


func _physics_process(delta):
	movement(delta)
	
	move_and_slide()
	
		

func movement(delta):
	if not (is_on_floor() and can_fly):
		velocity += get_gravity() * delta

	
	
	match AI_type:
		"sentry":
			if player: 
				direction = global_position.direction_to(player.global_position)
	
	direction_flip()

func direction_flip():
	pass
