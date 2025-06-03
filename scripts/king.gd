extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"../player"
@onready var health_bar: HealthBar = $"../CanvasLayer/HealthBar"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const IS_BOSS: bool = true
var bossHealth = 5

func _ready() -> void:
	health_bar._setup_health_bar(bossHealth)

func takeDamage(dmg: float):
	bossHealth -= dmg
	health_bar.changeValue(bossHealth)
	audio_stream_player_2d.play()
	
func _physics_process(delta: float) -> void:
	var playerPos = player.global_position - global_position
	if playerPos < Vector2.ZERO:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
