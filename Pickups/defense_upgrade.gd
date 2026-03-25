extends Pickup


func _physics_process(delta: float) -> void:
	rotation_degrees += 7.5*delta
	move_to_target()


func collect():
	super.collect()
	if target and target.get("change_player_stats"):
		if target is PlayerCharacter:
			target.change_player_stats(0, value)
		return value
