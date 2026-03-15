class_name PlayerCharacter extends Character

@export var player_sprite:AnimatedSprite2D

@export_group('Speed', '')

@export_range(0,1 ) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1
@export_range(0, 1) var jump_deceleration = 0.1
var fall_speed_multiplier: float = 1.0
var just_ground_slammed: bool = false
var ground_slam_fall_immune: bool = false

var gold: int = 0

# --- DASHING ---

#@export_category('Dashing')
@export_group('Dashing', '')

#@export var dash_curve:Curve
@export var dash_mult : float = 3.0
@export var dash_cooldown : float = 1.0
@export var dash_length : float = 0.3
@onready var dash_timer = dash_length

var dashing : bool = false
var can_dash : bool = true

# --- COYOTE TIMER ---

@onready var coyoteTimer = %coyoteTimer
var can_coyote : bool = true

var direction = Vector2.ZERO

var is_wallsliding = false

var facing_right:bool = true

var fall_height = 0
var is_falling:bool = false

var lock_horizontal_movement: bool = false

@onready var gun_offset: Marker2D = $GunOffset

@export_group('Miscellaneous', '')

@export var fall_damage_curve:Curve
@export var wall_slide_multiplier = 0.7
@export var wall_pushoff = 333


#var last_dir
#var just_wall_jumped:bool

@onready var sfx_jump: AudioStreamPlayer2D = $Sfx/SfxJump
@onready var sfx_power_up: AudioStreamPlayer2D = $Sfx/SfxPowerUp


var is_attacking : bool = false
var attack_slow_cooldown : bool = false

var _number_of_gold_nums : int = 0
#var _position_of_last_gold_num : Vector2 = Vector2.ZERO

func _ready():
	z_index = 8
	if get_tree().get_first_node_in_group('Player') != self:
		self.queue_free()
	self.call_deferred('reparent', get_tree().root)
	GlobalSignal.player_stat_change.emit()
	update_item()
	#if GlobalRoomChange.activate:
		#global_position = GlobalRoomChange.player_position
		#if GlobalRoomChange.player_jump_on_enter:
			#jump(1)
		#GlobalRoomChange.activate = false

func jump(power = 1):
	sfx_jump.play()
	velocity.y = -jump_velocity * power

#func _ready():
	#%dashCooldown.wait_time = dash_cooldown

func die():
	GlobalSignal.player_die.emit(self)
	#await GlobalSignal.player_finished_dying
	super.die()

func calculate_gun_offset_position():
	
	gun_offset.rotation += deg_to_rad(90)

func ground_slam():
	if not is_on_floor():
		
		ground_slam_fall_immune = true
		just_ground_slammed = true
		lock_horizontal_movement = true
		fall_speed_multiplier = 10
		
func _handle_ground_slam():
	GlobalSignal.player_ground_slam.emit(self)
	var new_slam = skills[2].instantiate()
	new_slam.position.y += 10
	add_child(new_slam)
	
	just_ground_slammed = false
	
	for i in range(1):
		await get_tree().physics_frame
	ground_slam_fall_immune = false

func _calculate_fall_damage(fall_distance):
	var fall_damage = 50 * fall_damage_curve.sample(fall_distance / 100)
	fall_height = 0
	hurt(false, fall_damage, 0, 0)
	GlobalSignal.player_stat_change.emit()
	GlobalSignal.player_hurt.emit()
	#hp -= fall_damage

func movement(delta):
	direction = Input.get_axis("left", "right")
	
	if not is_on_floor():
		if velocity.y > 0 and !is_falling:
			fall_height = global_position.y
			is_falling = true
		velocity += (get_gravity() * fall_speed_multiplier) * delta
		if coyoteTimer.is_stopped() and can_coyote:
			coyoteTimer.start()
			can_coyote = false
	elif not is_on_floor() and dashing:
		velocity.y = 0
	else:
		lock_horizontal_movement = false
		fall_speed_multiplier = 1
		
		
		if just_ground_slammed:
			_handle_ground_slam()
			
		var fall_distance = global_position.y - fall_height
		if is_falling and fall_distance > 200 and not (fall_immunity or ground_slam_fall_immune):
			_calculate_fall_damage(fall_distance)
			
		is_falling = false
		can_coyote = true
	
	if Input.is_action_just_pressed('down') and is_on_floor():
		set_collision_mask_value(2, false) #IDKKKKK
		
		print('awawa')
	else:
		set_collision_mask_value(2, true)
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyoteTimer.is_stopped() != true):
		jump()
		can_coyote = false
	
	if Input.is_action_pressed('down') and Input.is_action_just_pressed('jump') and not lock_horizontal_movement and not is_on_floor():
		just_ground_slammed = false
		
		ground_slam()
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_deceleration * fall_speed_multiplier
		
	
	if direction and not lock_horizontal_movement:
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

func attack_move_speed(power:float = 1.0, duration:float = 1.0):
	attack_slow_cooldown = true
	print('yay')
	var old_speed = speed
	speed /= power
	await get_tree().create_timer(duration).timeout
	speed = old_speed
	attack_slow_cooldown = false


func create_dmg_num(num:int, color_override:String = "#ffffff", text_override:String = ""):
	var col = "#cc1122"
	var txt = '-%d' % num
	super.create_dmg_num(num, col, txt)

func _physics_process(delta):
	
	movement(delta)
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		%dashCooldown.start()
	attacking()
	move_and_slide()

func attacking():
	var used_skill:int
	
	if Input.is_action_pressed("ability_1"):
		print(global_position)
		used_skill = 1
		if $skill1Timer.is_stopped():
			if not attack_slow_cooldown:
				attack_move_speed(1.5, 0.5)
			is_attacking = true
			var new_skill = skills[0]
			var skill_inst = new_skill.instantiate()
			if not facing_right:
				skill_inst.scale.x = -1
			else:
				skill_inst.scale.x = 1
			
			$RotationPoint.add_child(skill_inst)
			GlobalSignal.player_ability_1.emit()
			
			$skill1Timer.start()
	
	if Input.is_action_pressed("ability_2"):
		used_skill = 2
		if $skill2Timer.is_stopped():
			is_attacking = true
			var new_skill = skills[1]
			var skill_inst = new_skill.instantiate()
			skill_inst.global_position = global_position
			#if not facing_right:
				#skill_inst.scale.x = -1
			#else:
				#skill_inst.scale.x = 1
			calculate_gun_offset_position()
			gun_offset.add_child(skill_inst)
			GlobalSignal.player_ability_2.emit()
			
			$skill2Timer.start()
	
	
#func _unhandled_input(event):
	#pass

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

func update_item():
	for i in items:
		var new = i.instantiate()
		$Items.add_child(new)

func _on_dash_cooldown_timeout():
	can_dash = true


func _on_hurtbox_hurt(p_friendly: Variant, p_damage: Variant, p_angle: Variant, p_knockback: Variant, p_attacker: Variant) -> void:
	hurt(p_friendly, p_damage, p_angle, p_knockback)
	GlobalSignal.player_hurt.emit()
	GlobalSignal.player_stat_change.emit()
	print(p_friendly, p_damage, p_angle, p_knockback)

func _on_magnet_area_body_entered(body: Node2D) -> void:
	if body is Pickup:
		body.target = self

func gold_pickup_num(num):
	var lbl = Label.new()
	#lbl.scale = Vector2.ZERO
	lbl.add_theme_color_override('font_color', '#ffff00')
	lbl.add_theme_color_override('font_shadow_color', Color.BLACK)
	lbl.add_theme_constant_override('shadow_offset_x', 2)
	lbl.add_theme_constant_override('shadow_offset_y', 2)
	lbl.add_theme_font_size_override('font_size', 16)
	lbl.text = str("+%dG" % num)
	lbl.global_position = global_position 
	
	lbl.global_position.y -= 20 + (_number_of_gold_nums * 5)
	lbl.scale = Vector2(.5, .5)
	
	get_parent().add_child(lbl)
	_number_of_gold_nums += 1
	#_position_of_last_gold_num = lbl.global_position
	var tween = get_tree().create_tween()
	tween.tween_property(lbl, 'modulate:a', 0, 1)
	await tween.finished
	tween.kill()
	lbl.call_deferred('queue_free')
	_number_of_gold_nums -= 1

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body is Pickup:
		gold += body.collect()
		gold_pickup_num(body.collect())
		GlobalSignal.player_stat_change.emit()
