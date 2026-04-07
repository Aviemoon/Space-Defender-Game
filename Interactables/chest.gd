extends Interactable

@onready var drop_spawn_point: Marker2D = $DropSpawnPoint
@onready var cost_label: Label = $Control/costLabel

@export var difficulty_affected: bool = false
@export var cost: int = 0
@export_enum( 'random', 'all') var loot_type = 'all'

@export var infinite = false
@onready var wood: Sprite2D = $Wood
@onready var silver: Sprite2D = $Silver
var sprite
func _ready() -> void:
	super._ready()
	cost_label.text = str(cost) + 'G'
	if difficulty_affected:
		cost += 10 * Global.difficulty_modifier
	
	#cost += randi_range(-cost/10, cost/10) 
	#round(cost)
	
	if cost >= 200:
		wood.visible = false
		silver.visible = true
		sprite = $Silver
	else:
		sprite = $Wood
func interact():
	match loot_type:
		'random':
			var rand = drops.pick_random()
			var position_offset = drop_spawn_point.global_position
			for j in range(1, rand.num + 1):
				var new_drop = rand.drop.instantiate()
				new_drop.global_position = position_offset

				new_drop.gravity_scale = 0.25
				var velocity_modifier = (j) * 3
				if j < rand.num / 2:
					velocity_modifier *= -1
				elif j > (rand.num / 2):
					velocity_modifier /= 2
				else:
					velocity_modifier = 0

				if new_drop.get('value'):
					new_drop.value += rand.value_bonus
				new_drop.linear_velocity = Vector2(velocity_modifier, -150)
				get_parent().call_deferred('add_child', new_drop)
			if !infinite:
				opened = true
				sprite.modulate = Color(0.4, 0.4, 0.3)
				sprite.frame += 1
	
		'all':
			for i in drops:
				var position_offset = drop_spawn_point.global_position
				for j in range(1, i.num + 1):
					var new_drop = i.drop.instantiate()
					new_drop.global_position = position_offset

					new_drop.gravity_scale = 0.25
					var velocity_modifier = (j) * 3
					if j < i.num / 2:
						velocity_modifier *= -1
					elif j > (i.num / 2):
						velocity_modifier /= 2
					else:
						velocity_modifier = 0

					if new_drop.get('value'):
						new_drop.value += i.value_bonus
					new_drop.linear_velocity = Vector2(velocity_modifier, -150)
					get_parent().call_deferred('add_child', new_drop)
			if !infinite:
				opened = true
				sprite.modulate = Color(0.4, 0.4, 0.3)
	
				sprite.frame += 1
			else:
				cost += cost / 25
	player.gold -= cost

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player and player.gold >= cost and !opened:
		
		
		interact()
		$InteractHandler.interact.emit()
		$InteractHandler/InteractArea/Arrow.visible = false
		$InteractHandler/Control/InteractLabel.visible = false
		$Control/costLabel.visible = false


func _on_interact_area_body_entered(body: Node2D) -> void:
	player_enter(body)

func _on_interact_area_body_exited(body: Node2D) -> void:
	player_exit()
