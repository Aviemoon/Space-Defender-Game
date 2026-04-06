extends Node2D

@export var locked: bool = false
@export var spawn_time: float = 1.5
@export var ignore_stats:bool = false
@export var things_to_spawn: Array[SpawnInfo]


@onready var effect: Sprite2D = $Effect
@onready var spawn_timer: Timer = $spawnTimer

func _physics_process(delta: float) -> void:
	effect.rotation_degrees += delta * 3

func _ready() -> void:
	spawn_timer.wait_time = spawn_time

func spawn_stuff():
	if not things_to_spawn or Global.enemies_alive >= Global.enemy_limit or locked:
		return
	var diff = Global.difficulty_modifier
	
	var thing = things_to_spawn.pick_random()
	for i in range(thing.num):
		
		var inst = thing.enemy.instantiate()
		if thing.stats and !ignore_stats:
			inst.max_hp += thing.stats.hp
			inst.weapon_damage_bonus += thing.stats.dmg
			inst.speed += thing.stats.speed
			inst.jump_velocity += thing.stats.jumpspeed
			
			inst.max_hp *= diff
			inst.defense += diff
			inst.speed += diff
			inst.knockback_recovery += diff/4
			inst.speed += randi_range(-5, 12)
		inst.global_position = Vector2(global_position.x, global_position.y - 10)
		
		get_tree().root.add_child(inst)
		if !ignore_stats:
			Global.enemies_alive += 1
		await get_tree().create_timer(0.1).timeout


func _on_spawn_timer_timeout() -> void:
	spawn_timer.wait_time = spawn_time + randi_range(-0.9, 1)
	spawn_stuff()
