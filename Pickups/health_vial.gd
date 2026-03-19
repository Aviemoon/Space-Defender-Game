extends Pickup

@export var hp_value:int = 10

func _physics_process(delta: float) -> void:
	move_to_target()

func collect():
	super.collect()
	if target and target.get('heal'):
		print('haaa')
		target.heal(hp_value)
		return hp_value
