extends Character
class_name PlayerCharacter

@export var player_sprite:AnimatedSprite2D

@export_range(0,1 ) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1
@export_range(0, 1) var jump_deceleration = 0.1

@export var dash_speed = 900
@export var dash_max_dist = 300
@export var dash_curve:Curve
@export var dash_cooldown = 1

@export var wall_slide_multiplier = 0.7
@export var wall_pushoff = 333

@onready var coyoteTimer = %coyoteTimer
var can_coyote = true
var is_wallsliding = false
#var last_dir
#var just_wall_jumped:bool
#
#var is_dashing = false
#var dash_start_pos
#var dash_direction = 0
#var dash_timer = 0


func jump(power = 1):
	velocity.y = -jump_velocity * power

func movement(delta):
	var direction = Input.get_axis("left", "right")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		if coyoteTimer.is_stopped() and can_coyote:
			coyoteTimer.start()
			can_coyote = false
	else:
		can_coyote = true
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyoteTimer.is_stopped() != true):
		jump()
		can_coyote = false

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_deceleration
	
	if direction:
		velocity.x = move_toward(0, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * deceleration)
	
	if get_global_mouse_position().x < position.x:
		player_sprite.flip_h = true
	else:
		player_sprite.flip_h = false
	
func _physics_process(delta):
	movement(delta)
	#if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0:
		#is_dashing = true
		#dash_start_pos = position.x
		#dash_direction = direction
		#dash_timer = dash_cooldown
		#
	#print(is_dashing)
	#if is_dashing:
		#var current_dist = abs(position.x - dash_start_pos)
		#
		#if current_dist >= dash_start_pos or is_on_wall():
			#is_dashing = false
		#else:
			#velocity.x = dash_direction * dash_speed * dash_curve.sample(current_dist / dash_max_dist)
			#velocity.y = 0
	#
	#if dash_timer > 0:
		#dash_timer -= delta

	move_and_slide()



	
