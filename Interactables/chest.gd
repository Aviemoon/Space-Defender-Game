extends RigidBody2D

@export var action_name: String = 'Press E to Interact'
@export var drops: Array[PackedScene]
@export var number_of_coins: int = 5
@onready var drop_spawn_point: Marker2D = $DropSpawnPoint

var player = null
var opened = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player and not opened:
		for i in drops:
			var position_offset = drop_spawn_point.global_position.x - (len(drops) * number_of_coins)
			for j in range(number_of_coins):
				var new_drop = i.instantiate()
				new_drop.global_position = Vector2(position_offset + (j*3), drop_spawn_point.global_position.y)
				get_parent().call_deferred('add_child', new_drop)
		opened = true
		$Sprite2D.modulate = Color(0.3, 0.3, 0.3)


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter: 
		player = body
		#GlobalSignal.player_enter_interact_area.emit(self)
	else:
		player = null


func _on_interact_area_body_exited(body: Node2D) -> void:
	player = null
