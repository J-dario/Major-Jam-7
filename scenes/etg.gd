extends Node2D

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var audio_stream_player_2d_5: AudioStreamPlayer2D = $player/AudioStreamPlayer2D5

var actrivated = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	if actrivated == false:
		if body.IS_PLAYER:
			animation_player.play("intro")
			actrivated = true
