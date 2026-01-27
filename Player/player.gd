extends Character
class_name PlayerCharacter

@export var player_sprite:AnimatedSprite2D

@export_range(0,1 ) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1
@export_range(0, 1) var jump_deceleration = 0.1

# --- DASHING ---

@export var dash_mult:float = 3
#@export var dash_curve:Curve
@export var dash_cooldown = 1
var dashing = false
@export var dash_length = 0.3
@onready var dash_timer = dash_length
var can_dash:bool = true

@export var wall_slide_multiplier = 0.7
@export var wall_pushoff = 333

# --- COYOTE TIMER ---

@onready var coyoteTimer = %coyoteTimer
var can_coyote = true

var direction = Vector2.ZERO

var is_wallsliding = false

var facing_right:bool = true

var fall_height = 0
var is_falling:bool = false
@export var fall_damage_curve:Curve
#var last_dir
#var just_wall_jumped:bool

func _ready():
	if get_tree().get_first_node_in_group('Player') != self:
		self.queue_free()
	self.call_deferred('reparent', get_tree().root)
	#if GlobalRoomChange.activate:
		#global_position = GlobalRoomChange.player_position
		#if GlobalRoomChange.player_jump_on_enter:
			#jump(1)
		#GlobalRoomChange.activate = false

func jump(power = 1):
	velocity.y = -jump_velocity * power

#func _ready():
	#%dashCooldown.wait_time = dash_cooldown

func movement(delta):
	direction = Input.get_axis("left", "right")
	
	
	if not is_on_floor():
		if velocity.y > 0 and !is_falling:
			fall_height = global_position.y
			is_falling = true
		velocity += get_gravity() * delta
		if coyoteTimer.is_stopped() and can_coyote:
			coyoteTimer.start()
			can_coyote = false
	elif not is_on_floor() and dashing:
		velocity.y = 0
	else:
		var fall_distance = global_position.y - fall_height
		if is_falling and fall_distance > 100:
			var fall_damage = 100 * fall_damage_curve.sample(fall_distance / 100)
			fall_height = 0
			hp -= fall_damage
			
		is_falling = false
		can_coyote = true
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyoteTimer.is_stopped() != true):
		jump()
		can_coyote = false

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_deceleration
	
	if direction:
		#if dashing:
			#velocity.x = move_toward(0, direction * speed, speed * acceleration * dash_mult)
			#dash_timer -= delta
			#if dash_timer < 0:
				#dash_timer = dash_length
				#dashing = false
			#print(dash_timer)
		#else:
		
		velocity.x = move_toward(0, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * deceleration)

	
	if get_global_mouse_position().x < position.x:
		player_sprite.flip_h = true
		facing_right = false
	else:
		player_sprite.flip_h = false
		facing_right = true
	
func _physics_process(delta):
	movement(delta)

	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		%dashCooldown.start()
	
	if Input.is_action_pressed("ability_1"):
		if $skill1Timer.is_stopped():
			var new_skill = skills[0]
			var skill_inst = new_skill.instantiate()
			if not facing_right:
				skill_inst.scale.x = -1
			else:
				skill_inst.scale.x = 1
				#if skill_inst.get("sprite"):
					#skill_inst.sprite.flip_v = true
			$RotationPoint.add_child(skill_inst)
			GlobalSignal.player_ability_1.emit()
			$skill1Timer.start()
	move_and_slide()

	
func _unhandled_input(event):
	pass

#func _input(event):
	#if event.is_action_pressed("ability_1"):
		#if $skill1Timer.is_stopped():
			#var new_skill = skills[0]
			#var skill_inst = new_skill.instantiate()
			#if not facing_right:
				#skill_inst.rotation = PI
				#if skill_inst.get("sprite"):
					#skill_inst.sprite.flip_v = true
			#$RotationPoint.add_child(skill_inst)
			#GlobalSignal.player_ability_1.emit()
			#$skill1Timer.start()


func _on_dash_cooldown_timeout():
	can_dash = true
