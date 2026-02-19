extends AnimatedSprite2D





func _on_audio_stream_player_2d_finished() -> void:
	call_deferred('queue_free')


func _on_animation_finished() -> void:
	visible = false
