extends AnimatedSprite2D

@onready var sfx: AudioStreamPlayer2D = $sfx


func _ready() -> void:
	if Global.sfx_num < 2:
		print(Global.sfx_num)
		sfx.play()
		Global.sfx_num += 1
	else:
		call_deferred('queue_free')
	#sfx.play()


func _on_audio_stream_player_2d_finished() -> void:
	Global.sfx_num -= 1
	call_deferred('queue_free')


func _on_animation_finished() -> void:
	visible = false
