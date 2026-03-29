extends BaseEnemy

@onready var wall_check: Area2D = $WallCheck
var facing_left = true
@onready var attack_timer: Timer = $attackTimer

func _ready():
	player = get_tree().get_nodes_in_group('Player').pick_random()

func _physics_process(delta: float) -> void:
	movement(delta)
	if velocity.x > 0.1:
		wall_check.rotation = 0
		facing_left = false
	else:
		wall_check.rotation = PI
		facing_left = true
	
	#if player.global_position.x > global_position:
		
	
	move_and_slide()

func jump(power = 1):
	super.jump(power)

func attack():
	sprite.play('attack')
	var inst: BaseProjectile = skills[0].instantiate()
	inst.global_position = global_position
	#inst.damage = 
	if facing_left:
		inst.scale.x = -1
	inst.scale *= weapon_size_mult
	#print('ENEMYYY ATTACKK!!')
	call_deferred('add_child', inst)
	await sprite.animation_finished
	sprite.play('walk')

func _on_hurtbox_hurt(p_friendly: Variant, p_damage: Variant, p_angle: Variant, p_knockback: Variant, p_attackerd: Variant) -> void:
	hurt(p_friendly, p_damage, p_angle, p_knockback, p_attackerd)
	#if randi_range(1, 15) == 5:
			#attack()
	$sfxHit.play()


func _on_wall_check_body_entered(body: Node2D) -> void:
	if is_on_floor():
		jump() #:3
	await get_tree().create_timer(0.3).timeout
	if body:jump()


func _on_attack_timer_timeout() -> void:
	attack()


func _on_target_attack_zone_body_entered(body: Node2D) -> void:
	if attack_timer.is_stopped():
		if randi_range(1, 5) == 5:
			attack()
		attack_timer.start()


func _on_target_attack_zone_body_exited(body: Node2D) -> void:
	attack_timer.stop()


func _on_platform_timer_timeout() -> void:
	jump_check()
