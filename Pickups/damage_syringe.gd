extends Pickup


func _physics_process(delta: float) -> void:
	rotation_degrees += 7.5*delta
	move_to_target()


func collect():
	super.collect()
	if target and target.get("change_weapon_stats"):
		if target is PlayerCharacter:
			target.change_weapon_stats(value)
		return value
