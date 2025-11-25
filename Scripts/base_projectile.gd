extends Area2D
class_name BaseProjectile

@export var base_damage:float = 0
@export var base_speed:float = 0
@export var base_health:int = 0
@export var base_knockback:float = 0

var damage 
var speed = base_speed
var knockback = base_knockback
var health = base_health

func calculate_stats():
	damage = base_damage
	speed = base_speed
	knockback = base_knockback
	health = base_health
