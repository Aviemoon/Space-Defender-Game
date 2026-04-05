extends Node2D

signal interact

var _already_interacted = false
@onready var interact_label: Label = $Control/InteractLabel
@onready var arrow: Sprite2D = $InteractArea/Arrow

@export var can_show: bool = true
#@export var arrow_y_offset: int = 0

func _ready() -> void:
	if get_parent() and (get_parent() is Interactable or get_parent() is InteractArea):
		var parent = get_parent()
		interact_label.hide()
		interact_label.text = parent.action_name
		

func _on_interact_area_body_entered(_body: Node2D) -> void:
	if not _already_interacted and can_show:
		interact_label.show()


func _on_interact_area_body_exited(_body: Node2D) -> void:
	if not _already_interacted:
		interact_label.hide()


func _on_interact() -> void:
	_already_interacted = true
	interact_label.hide()
