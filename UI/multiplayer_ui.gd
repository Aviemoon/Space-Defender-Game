extends Control

@onready var timer_label: Label = $TimerLabel
@onready var pause_ui: Control = $PauseUI

@export var player1: PlayerCharacter
@export var player2: PlayerCharacter

@onready var p_1_hp_label: Label = $player1vbox/p1hpLabel
@onready var p_1_gold_label: Label = $player1vbox/p1goldLabel

@onready var p_2_hp_label: Label = $player2vbox/p2hpLabel
@onready var p_2_gold_label: Label = $player2vbox/p2goldLabel

var seconds = 0
var minutes = 0


func _ready() -> void:
	GlobalSignal.player_stat_change.connect(update_labels)
	
	
	
	
		#print(file_name)
	
	
	
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('pause'):
		pause_game()

func _process(delta: float) -> void:
	if not get_tree().paused:
			seconds += delta
			if seconds > 60:
				seconds -= 60
				minutes += 1
			timer_label.text = "%02d:%02d" % [minutes, seconds]

func update_labels(playa):
	#print("AWAAWAWAWAAAWAWAWA")
	
	if !player1 or !player2:
		return
	if player1.hp > 0:
		p_1_hp_label.text = "Health: %d / %d" % [player1.hp, player1.max_hp]
	else:
		p_1_hp_label.text = "DEAD!!"
		p_1_hp_label.modulate = Color(255, 0 , 0)
	p_1_gold_label.text = "Gold: %d" % player1.gold
	
	if player2.hp > 0:
		p_2_hp_label.text = "Health: %d / %d" % [player2.hp, player2.max_hp]
	else:
		p_2_hp_label.text = "DEAD!!"
		p_2_hp_label.modulate = Color(255, 0 , 0)
	p_2_gold_label.text = "Gold: %d" % player2.gold


func pause_game():
	get_tree().paused = !get_tree().paused
	pause_ui.visible = !pause_ui.visible


func _on_unpause_pressed() -> void:
	pause_game()


func _on_quit_menu_pressed() -> void:
	pause_game()
	for i in get_tree().get_nodes_in_group('Player'):
		i.call_deferred('queue_free')
	get_tree().change_scene_to_file('res://UI/main_menu.tscn')
	get_tree().paused = false

func _on_quit_desktop_pressed() -> void:
	get_tree().quit()


#func _on_tree_entered() -> void:
	#GlobalSignal.player_stat_change.connect(update_labels)
#
#
func _on_tree_exited() -> void:
	GlobalSignal.player_stat_change.disconnect(update_labels)
