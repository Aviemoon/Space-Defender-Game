extends Item

@export var effect: PackedScene


func explode(hit_object: Node2D):
	var new_explosion = effect.instantiate()
	new_explosion.global_position = hit_object.global_position
	get_tree().root.add_child(new_explosion)
	
	#print(hit_object)

func _on_tree_entered() -> void:
	GlobalSignal.character_hit.connect(explode)

func _on_tree_exited() -> void:
	GlobalSignal.character_hit.disconnect(explode)
