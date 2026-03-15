extends Interactable

@onready var drop_spawn_point: Marker2D = $DropSpawnPoint



@export var number_of_coins: int = 5



func interact():
	$Sprite2D.frame += 1
	for i in drops:
		#var position_offset = drop_spawn_point.global_position.x - (len(drops) * number_of_coins)
		var position_offset = drop_spawn_point.global_position
		for j in range(1, number_of_coins + 1):
			var new_drop = i.instantiate()
			new_drop.global_position = position_offset
			if new_drop is Coin:
				new_drop.gravity_scale = 0.25
			
			var velocity_modifier = (j) * 3
			if j < number_of_coins / 2:
				velocity_modifier *= -1
			elif j > (number_of_coins / 2):
				velocity_modifier /= 2
			else:
				velocity_modifier = 0
			print(velocity_modifier)
			
			new_drop.linear_velocity = Vector2(velocity_modifier, -150)
			get_parent().call_deferred('add_child', new_drop)
	opened = true
	$Sprite2D.modulate = Color(0.4, 0.4, 0.3)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player and not opened:
		interact()
		$InteractHandler.interact.emit()


func _on_interact_area_body_entered(body: Node2D) -> void:
	player_enter(body)

func _on_interact_area_body_exited(body: Node2D) -> void:
	player_exit()
