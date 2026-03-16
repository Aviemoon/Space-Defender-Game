extends CanvasLayer
#@onready var camera_2d: Camera2D = $Control/Camera2D

@export var parallax_multiplier: float = 2
@onready var parallax_layer: ParallaxLayer = $Control/ParallaxBackground/ParallaxLayer



func _input(event):
	if event is InputEventMouseMotion:
		var mouse_x = event.position.x
		var mouse_y = event.position.y
		
		var viewport_size = get_viewport().get_visible_rect().size
		print(viewport_size)
		
		var relative_x = (mouse_x - (viewport_size.x/2)) / (viewport_size.x/2)
		var relative_y = (mouse_y - (viewport_size.y/2)) / (viewport_size.y/2)
		
		parallax_layer.motion_offset.x = parallax_multiplier * relative_x
		parallax_layer.motion_offset.y = parallax_multiplier * relative_y

func _on_start_button_pressed() -> void:
	SceneManager.transition_scene('uid://cugfsoo4pjghg', '', Vector2.ZERO, '')
