extends Node2D

signal interact

var _already_interacted = false
@onready var interact_label: Label = $Control/InteractLabel


func _ready() -> void:
	if get_parent() and get_parent() is Interactable:
		var parent: Interactable = get_parent()
		interact_label.hide()
		interact_label.text = parent.action_name
		


func _on_interact_area_body_entered(body: Node2D) -> void:
	if not _already_interacted:
		interact_label.show()


func _on_interact_area_body_exited(body: Node2D) -> void:
	if not _already_interacted:
		interact_label.hide()


func _on_interact() -> void:
	_already_interacted = true
	interact_label.hide()
