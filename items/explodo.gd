extends Item

@export var effect: PackedScene
const DAMAGE_RADIUS = preload("uid://cnw6oi4qfmamk")


func explode(hit_object: Node2D, idk = null):
	var new_explosion = effect.instantiate()
	new_explosion.global_position = hit_object.global_position
	get_tree().root.add_child(new_explosion)
	#
	#var dmg_rad: BaseProjectile = DAMAGE_RADIUS.instantiate() # LATERRRR!!
	#dmg_rad.global_position = hit_object.global_position
	#dmg_rad.scale *= 2
	#dmg_rad.base_damage += damage
#
	#get_tree().root.call_deferred('add_child', dmg_rad)
	#
func _on_tree_entered() -> void:
	GlobalSignal.enemy_die.connect(explode)

func _on_tree_exited() -> void:
	GlobalSignal.enemy_die.disconnect(explode)
