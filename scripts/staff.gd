extends Node2D

const bulletScene = preload("res://scenes/bullet.tscn")

@onready var rotationOffset: Node2D = $RotationOffset
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var rotation_offset: Node2D = $RotationOffset
@onready var shoot_pos: Marker2D = $RotationOffset/staffSprite/shootPos
@onready var shoot_timer: Timer = $shootTimer

var timeBetweenShots: float = 0.5
var canShoot: bool = false

func _ready() -> void:
	shoot_timer.wait_time = timeBetweenShots

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Test3"):
		canShoot = true
	
	var player = get_parent().player
	var playerPos = player.global_position - global_position + Vector2(0,75)
	if playerPos < Vector2.ZERO:
		playerPos = -playerPos
		rotation_offset.scale.x = -1
	else:
		rotation_offset.scale.x = 1
		
	rotationOffset.rotation = lerp_angle(rotationOffset.rotation, playerPos.angle(), 6.5*delta)
	
	if canShoot == true:
		_shoot()
		canShoot = false
		shoot_timer.start()

func _shoot():
	audio_stream_player_2d.play()
	var newBullet = bulletScene.instantiate()
	newBullet.global_position = shoot_pos.global_position
	newBullet.global_rotation = shoot_pos.global_rotation
	get_tree().root.add_child(newBullet)


func _on_shoot_timer_timeout() -> void:
	canShoot = true
