extends CharacterBody2D

const IS_PLAYER: bool = true

const bulletScene = preload("res://scenes/laser_shuriken.tscn")
@onready var shootPos: Marker2D = $Marker2D
@onready var shoot_timer: Timer = $shootTimer
@onready var laser: AudioStreamPlayer2D = $Laser
@onready var player_health_bar: PlayerHealthBar = $"../CanvasLayer/PlayerHealthBar"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt: AudioStreamPlayer2D = $hurt
@onready var i_frames: Timer = $iFrames
@onready var vignette: ColorRect = $"../CanvasLayer/Vignette"

var isInvincible: bool = false
var canShoot: bool = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	changeAS(GameManager.timeBetweenShots)
	GameManager.shurikenGun = self

func _physics_process(delta: float) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if GameManager.playerCanMove == false:
		return
		
	_movement(delta)
	
	if Input.is_action_pressed("shoot") and canShoot:
		_shoot()
		canShoot = false
		shoot_timer.start()
	move_and_slide()

func _movement(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	velocity = lerp(velocity, input_vector * GameManager.movementSpeed, 22.0 * delta)

func freeze_frame(timescale: float, duration: float) -> void:
	Engine.time_scale = timescale
	vignette.visible = true
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
	vignette.visible = false
	
func takeDamage():
	if !isInvincible:
		isInvincible = true
		player_health_bar.takeDMG()
		animation_player.play("hit")
		hurt.play()
		freeze_frame(0.2, 0.3)
		i_frames.start()
		
func _shoot():
	laser.play()
	var newBullet = bulletScene.instantiate()
	get_tree().root.add_child(newBullet)
	newBullet.global_position = shootPos.global_position
	
func changeAS(time: float):
	shoot_timer.wait_time = time

func _on_shoot_timer_timeout() -> void:
	canShoot = true


func _on_i_frames_timeout() -> void:
	isInvincible = false


func _on_hurt_finished() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if GameManager.currentHealth == 0:
		GameManager.playerDed()
