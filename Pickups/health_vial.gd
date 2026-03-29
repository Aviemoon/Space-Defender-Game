extends Pickup

#@export var hp_value:int = 10

func _physics_process(delta: float) -> void:
	rotation_degrees += 7.5*delta
	move_to_target()

func collect():
	super.collect()
	if target and target.get('heal'):
		#print('haaa')
		target.heal(value)
		return [value, txt_color, txt_extra]
