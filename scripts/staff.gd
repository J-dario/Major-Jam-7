extends Node2D

const bulletScene = preload("res://scenes/bullet.tscn")
const tripleShot = preload("res://scenes/triple_shot.tscn")
const pair = preload("res://scenes/pair.tscn")
const feathers = preload("res://scenes/feather_burst.tscn")
const sixteen = preload("res://scenes/16.tscn")

@onready var king: CharacterBody2D = $".."
@onready var rotationOffset: Node2D = $RotationOffset
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var rotation_offset: Node2D = $RotationOffset
@onready var shoot_pos: Marker2D = $RotationOffset/staffSprite/shootPos
@onready var shoot_timer: Timer = $shootTimer
@onready var attack_cd: Timer = $attackCD
@onready var tele: CPUParticles2D = $RotationOffset/staffSprite/Tele
@onready var kingAnimAlmost: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var kingAnimPlayer: AnimationPlayer = $"../AnimatedSprite2D/AnimationPlayer"
@onready var attack_duration: Timer = $AttackDuration
@onready var timer: Timer = $AttackDuration/Timer
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

var timeBetweenShots: float = 0.5
var canShoot: bool = false
var notCooldown: bool = true

var attackIndex = GameManager.bossPhase

func _ready() -> void:
	shoot_timer.wait_time = timeBetweenShots
	kingAnimPlayer.animation_finished.connect(checkAnim)

func beginShootin():
	canShoot = true

var tripleCounter = 3
var pairCounter = 10
var featherCounter = 5
var shouldPlayAnim = true
var onGround = true
var sixeen = 0
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
				attack_cd.wait_time = 1
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
				attack_cd.wait_time = 1
				attack_cd.start()
				pairCounter = 0
		elif attackIndex == 3:
			if !shouldPlayAnim:
				if featherCounter < 5:
					featherShot()
					featherCounter += 1
				else:
					kingAnimAlmost.play("phase3Idle")
					notCooldown = false
					attack_cd.wait_time= 1.5
					attack_cd.start()
					featherCounter = 0
			else:
				kingAnimPlayer.play("phase3WindUp")
				
		elif attackIndex == 4:		
			if shouldPlayAnim:
				kingAnimPlayer.play("phase3WindUp")
			if !onGround:
				if sixeen < 3:
					sixTen()
					sixeen += 1
				else:
					tele.emitting = true
					tele.one_shot = false
					tele.modulate.a = 255
					notCooldown = false
					attack_cd.wait_time = 1
					attack_cd.start()
					sixeen = 0
					attackIndex = 0


func featherShot():
	shoot_timer.wait_time = 0.3
	canShoot = false
	shoot_timer.start()
	audio_stream_player_2d.play()
	var newfeather = feathers.instantiate()
	newfeather.global_position = shoot_pos.global_position
	newfeather.global_rotation = shoot_pos.global_rotation
	get_tree().root.add_child(newfeather)

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
	
func sixTen():
	tele.emitting = false
	tele.one_shot = true
	tele.modulate.a = 0
	shoot_timer.wait_time = 0.3
	canShoot = false
	shoot_timer.start()
	audio_stream_player_2d.play()
	var sixes = sixteen.instantiate()
	sixes.global_position = shoot_pos.global_position
	sixes.global_rotation = shoot_pos.global_rotation
	get_tree().root.add_child(sixes)
	
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
	if attackIndex == 3:
		kingAnimAlmost.play("phase3Idle")
	attackIndex = -1
	print("waiting")
	var wait_timer := Timer.new()
	wait_timer.wait_time = 0.5
	wait_timer.one_shot = true
	add_child(wait_timer)
	wait_timer.start()
	await wait_timer.timeout 
	print("donew")
	randomize()
	attackIndex = randi_range(0, GameManager.bossPhase)
	shouldPlayAnim = true
	print(attackIndex)
	if attackIndex == 0:
		attack_duration.wait_time = 5
		attack_duration.start()
	elif attackIndex == 1:
		attack_duration.wait_time =5
		attack_duration.start()
	elif attackIndex == 2:
		attack_duration.wait_time = 5
		attack_duration.start()
	elif attackIndex == 3:
		attack_duration.wait_time = 8
		attack_duration.start()
	elif attackIndex == 4:
		attack_duration.wait_time = 5
		attack_duration.start()

	#attackIndex = 4

func _on_attack_cd_timeout() -> void:
	notCooldown = true
	if attackIndex == 3:
		shouldPlayAnim = true


func checkAnim(anim_name: String) -> void:
	if anim_name == "phase3WindUp" && attackIndex == 3:
		shouldPlayAnim = false
		kingAnimAlmost.play("phase3BetterShot")
	elif anim_name == "phase3WindUp" && attackIndex == 4:
		shouldPlayAnim = false
		onGround = false
		kingAnimPlayer.play("phase3Jump")
		timer.start()
	elif anim_name == "phase3Land":
		kingAnimAlmost.play("phase3Idle")

func _on_timer_timeout() -> void:
	shouldPlayAnim = true
	kingAnimPlayer.play("phase3Land")
