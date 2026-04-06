class_name BaseEnemy extends Character 

@export_enum("sentry", "wander", "custom") var AI_type = "sentry"
@export var can_fly:bool = false
@export var knockback_recovery:float = 10
@export var weapon_size_mult:float = 1
const GOLD = preload("res://Pickups/coin.tscn")
const ALERT = preload("res://UI/alert_notifier.tscn")
#var knockback


var direction:Vector2
#@onready var player = get_tree().get_first_node_in_group("player")
var player: PlayerCharacter
@export var sprite:AnimatedSprite2D

func _ready():
	pass



func _physics_process(delta):
	#player = get_tree().get_first_node_in_group("player")
	
	movement(delta)
	move_and_slide()
	
func die():
	Global.enemies_alive -= 1
	GlobalSignal.enemy_die.emit(self)
	for i in range(randi_range(1, 3)):
		var new_coin = GOLD.instantiate()
		
		new_coin.global_position = global_position + Vector2(randi_range(2, 5), randi_range(2, 5)) 
		#if new_coin: print('awa')
		
		get_parent().call_deferred('add_child', new_coin)
	super.die()
	
func jump(power = 1):
	velocity.y = -jump_velocity * power

func movement(delta):
	if not is_on_floor() or can_fly:
		velocity += get_gravity() * delta
		#print('aaa')

	
	
	match AI_type:
		"sentry":
			if player: 
				direction = global_position.direction_to(player.global_position)
				
		"wander":
			
			if not player:
				if get_tree().get_nodes_in_group('Player'): 
					player = get_tree().get_nodes_in_group('Player').pick_random()
					
			#print(player)
			knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
			direction = global_position.direction_to(player.global_position)
			velocity.x = direction.x * speed
			velocity += knockback 
			
			if player.global_position.y < global_position.y  and is_on_floor() and abs(player.global_position.x - global_position.x) < 180:
				jump()
				#print('i should jump')
			
	
	direction_flip()

func jump_check():
	if !player:
		return

	if player.global_position.y +1 > global_position.y :
		#print('player: %d' % player.global_position.y, '\n', 'me %d' % global_position.y)

		
		platform_collision_mask_defer()
		
	#elif is_on_floor() and !get_collision_mask_value(2):
		#set_collision_mask_value(2, true)
	#else:
		#call_deferred('set_collision_mask_value', 2, true)

func platform_collision_mask_defer():
	#await get_tree().create_timer(0.01).timeout
	set_collision_mask_value(2, false)
	await get_tree().physics_frame

	#call_deferred('set_collision_mask_value', 2, true)
	set_collision_mask_value(2, true)

	

func direction_flip():
	#print(direction)
	if direction.x > 0.1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
