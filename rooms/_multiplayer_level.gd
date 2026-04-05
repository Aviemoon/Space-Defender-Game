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

#
#func _input(event):
	#var deviceId = event.device
	##print('awa')
	### Check to see that that event id on an action
	#if not players.get(deviceId) and event.is_action_pressed("jump"):
		#
		### create the player scene instance
		#var playerScene = preload("res://Player/player.tscn")
		#var player: PlayerCharacter = playerScene.instantiate()
		#
		### give it a name so it's unique, if you really want
		#player.set_name('player' + str(deviceId))
		#
		#player.speed = 230
		#
		### Give the player instance a device id so it can handle its own events
		#player.deviceId = deviceId
		### register the player in the players dict
		#players[deviceId] = player
		#
		### Add the player to the scene
		#add_child(player)
		##if player.get('is_multiplayer'):
		#player.maltipla = true


func _on_difficulty_timer_timeout() -> void:
	Global.difficulty_modifier += 1
