extends Node2D

@export var spawn_time: float = 1.5
@export var things_to_spawn: Array[SpawnInfo]

@onready var effect: Sprite2D = $Effect
@onready var spawn_timer: Timer = $spawnTimer

func _physics_process(delta: float) -> void:
	effect.rotation_degrees += delta * 3

func _ready() -> void:
	spawn_timer.wait_time = spawn_time

func spawn_stuff():
	if not things_to_spawn or Global.enemies_alive >= Global.enemy_limit:
		return
	
	
	var thing = things_to_spawn.pick_random()
	for i in range(thing.num):
		var inst: BaseEnemy = thing.enemy.instantiate()
		if thing.stats:
			inst.max_hp += thing.stats.hp
			inst.damage += thing.stats.dmg
			inst.speed += thing.stats.speed
			inst.jump_velocity += thing.stats.jumpspeed
		inst.speed += randi_range(-5, 12)
		inst.global_position = Vector2(global_position.x, global_position.y - 10)
		get_tree().root.add_child(inst)
		Global.enemies_alive += 1


func _on_spawn_timer_timeout() -> void:
	spawn_stuff()
