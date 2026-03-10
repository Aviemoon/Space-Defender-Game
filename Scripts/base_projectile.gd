class_name BaseProjectile extends Area2D

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
	damage = base_damage
	speed = base_speed
	knockback = base_knockback
	health = base_health

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

func enemy_hit(charge = 1) -> void:
	health -= charge
	
	if health <= 0:
		collision.call_deferred('set', 'disabled', true)
		visible = false
		#await get_tree().create_timer(1).timeout
		call_deferred('queue_free')
