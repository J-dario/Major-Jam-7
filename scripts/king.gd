extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"../player"
@onready var health_bar: HealthBar = $"../CanvasLayer/HealthBar"
@onready var health_bar2: HealthBar = $"../CanvasLayer/HealthBar2"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hitflashanim: AnimationPlayer = $hitflashanim
@onready var king: CharacterBody2D = $"."
@onready var health_bar_3: HealthBar = $"../CanvasLayer/HealthBar3"

var speed: float = 65.0
var should_chase: bool = false

var usableBar

const IS_BOSS: bool = true

func _ready() -> void:
	usableBar = health_bar
	usableBar._setup_health_bar(GameManager.bossHealth)

func phase2():
	health_bar2.visible = true
	GameManager.bossHealth = 20
	health_bar2._setup_health_bar(GameManager.bossHealth)
	usableBar = health_bar2
	if health_bar:
		health_bar.queue_free()

func phase3():
	health_bar_3.visible = true
	GameManager.bossHealth = 30
	health_bar_3._setup_health_bar(GameManager.bossHealth)
	usableBar = health_bar_3
	if health_bar2:
		health_bar2.queue_free()
	

func takeDamage(dmg: float):
	GameManager.bossHealth -= dmg
	usableBar.changeValue(GameManager.bossHealth)
	audio_stream_player_2d.play()
	hitflashanim.play("hit")
	print(GameManager.bossHealth)
	if GameManager.bossHealth <= 0:
		GameManager.bossPhase += 1
		GameManager.phaseChange.emit()
	
func _physics_process(delta: float) -> void:
	var playerPos = player.global_position - global_position
	if playerPos < Vector2.ZERO:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	
	if should_chase:
		var direction = playerPos.normalized()
		velocity = lerp(velocity, direction*speed, 8.5*delta)
		move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		body.takeDamage()
		should_chase = false
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		should_chase = true
