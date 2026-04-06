extends Node2D

const PLAYER = preload("uid://bn3p2gijv0tv2")
const BG_DIR = "res://Sprites/Backgrounds/"

@onready var bg: Sprite2D = $BG

var players = {}

func _ready() -> void:
	var new_player = PLAYER.instantiate()
	$Players.add_child(new_player)
	
	for i in $Players.get_children():
		i.speed = 240
	

func _process(delta: float) -> void:
	bg.rotation_degrees += delta / 3


func _on_difficulty_timer_timeout() -> void:
	Global.difficulty_modifier += 1
