class_name BaseProjectile extends Area2D

@export var death_fx: AnimatedSprite2D

@export var base_damage:float = 0
@export var base_speed:float = 0
@export var base_health:int = 0
@export var base_knockback:float = 0

@export var collision:CollisionShape2D
@export var sprite:Node2D


var damage 
var speed = base_speed
var knockback = base_knockback
var health = base_health

var angle = Vector2.ZERO

func calculate_stats():
	var parent = get_parent()
	if parent is Marker2D:
		parent = parent.get_parent()
	damage = base_damage + parent.get("weapon_damage_bonus")
	speed = base_speed + parent.get('weapon_speed_bonus')
	knockback = base_knockback + parent.get('weapon_knockback_bonus') 
	health = base_health + parent.get('weapon_hp_bonus')


func go_to_rotation(delta) -> bool:
	angle = Vector2.RIGHT.rotated(rotation)
	var direction = angle * speed
	position += direction * delta
	return true
 
func death_effect(fx: AnimatedSprite2D):
	if not fx:
		return
	fx.reparent(get_tree().root)
	fx.visible = true
	
	fx.play('')
	fx.animation_finished.connect(Callable(fx, 'queue_free'))

func enemy_hit(enemy, charge = 1) -> void:
	health -= charge
	
	#if enemy is Character:
		#GlobalSignal.character_hit.emit(enemy, self)
	
	
	if health <= 0:
		collision.call_deferred('set', 'disabled', true)
		visible = false
		#await get_tree().create_timer(1).timeout
		call_deferred('queue_free')
