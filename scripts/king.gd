extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"../player"
@onready var health_bar: HealthBar = $"../CanvasLayer/HealthBar"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hitflashanim: AnimationPlayer = $hitflashanim
@onready var PICKUP_COIN__2_ = preload("res://sounds/pickupCoin (2).wav")

const lines: Array[String] = [
	"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
	"Goobus",
	"Vrrobis"
]

const IS_BOSS: bool = true
var bossHealth = 10

func _ready() -> void:
	health_bar._setup_health_bar(bossHealth)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Test2"):
		DialogManager.start_dialog(global_position, lines, PICKUP_COIN__2_)
		
func takeDamage(dmg: float):
	bossHealth -= dmg
	health_bar.changeValue(bossHealth)
	audio_stream_player_2d.play()
	hitflashanim.play("hit")
	
func _physics_process(delta: float) -> void:
	var playerPos = player.global_position - global_position
	if playerPos < Vector2.ZERO:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
