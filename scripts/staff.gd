extends Node2D

const bulletScene = preload("res://scenes/bullet.tscn")
const tripleShot = preload("res://scenes/triple_shot.tscn")
const pair = preload("res://scenes/pair.tscn")


@onready var rotationOffset: Node2D = $RotationOffset
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var rotation_offset: Node2D = $RotationOffset
@onready var shoot_pos: Marker2D = $RotationOffset/staffSprite/shootPos
@onready var shoot_timer: Timer = $shootTimer
@onready var attack_cd: Timer = $attackCD
@onready var tele: CPUParticles2D = $RotationOffset/staffSprite/Tele

var timeBetweenShots: float = 0.5
var canShoot: bool = false
var notCooldown: bool = true

var attackIndex = GameManager.bossPhase

func _ready() -> void:
	shoot_timer.wait_time = timeBetweenShots

func beginShootin():
	canShoot = true

var tripleCounter = 3
var pairCounter = 10
func _physics_process(delta: float) -> void:
	var player = get_parent().player
	var playerPos = player.global_position - global_position + Vector2(0,75)
	if playerPos < Vector2.ZERO:
		playerPos = -playerPos
		rotation_offset.scale.x = -1
	else:
		rotation_offset.scale.x = 1
		
	rotationOffset.rotation = lerp_angle(rotationOffset.rotation, playerPos.angle(), 6.5*delta)
	
	if canShoot == true && GameManager.enemyCanAttack == true && notCooldown:
		if attackIndex == 0:
			_shoot()
		elif attackIndex == 1:
			if tripleCounter < 3:
				triple()
				tripleCounter += 1
			else:
				tele.emitting = true
				tele.one_shot = false
				tele.modulate.a = 255
				notCooldown = false
				attack_cd.start()
				tripleCounter = 0
		elif attackIndex == 2:
			if pairCounter < 10:
				pairShot()
				pairCounter += 1
			else:
				tele.emitting = true
				tele.one_shot = false
				tele.modulate.a = 255
				notCooldown = false
				attack_cd.start()
				pairCounter = 0

func pairShot():
	tele.emitting = false
	tele.one_shot = true
	tele.modulate.a = 0
	shoot_timer.wait_time = 0.1
	canShoot = false
	shoot_timer.start()
	audio_stream_player_2d.play()
	var newPair = pair.instantiate()
	newPair.global_position = shoot_pos.global_position
	newPair.global_rotation = shoot_pos.global_rotation
	get_tree().root.add_child(newPair)

func triple():
	tele.emitting = false
	tele.one_shot = true
	tele.modulate.a = 0
	shoot_timer.wait_time = 0.3
	canShoot = false
	shoot_timer.start()
	audio_stream_player_2d.play()
	var newTriple = tripleShot.instantiate()
	newTriple.global_position = shoot_pos.global_position
	newTriple.global_rotation = shoot_pos.global_rotation
	get_tree().root.add_child(newTriple)
	

func _shoot():
	tele.emitting = true
	tele.modulate.a = 255
	shoot_timer.wait_time = 0.5
	randomize()
	canShoot = false
	shoot_timer.start()
	var randRot = randf_range(-0.2, 0.2)
	audio_stream_player_2d.play()
	var newBullet = bulletScene.instantiate()
	newBullet.global_position = shoot_pos.global_position
	newBullet.global_rotation = shoot_pos.global_rotation + randRot
	get_tree().root.add_child(newBullet)

func _on_shoot_timer_timeout() -> void:
	canShoot = true

func _on_attack_duration_timeout() -> void:
	randomize()
	attackIndex = randi_range(0, GameManager.bossPhase)

func _on_attack_cd_timeout() -> void:
	notCooldown = true
