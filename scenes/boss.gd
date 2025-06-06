extends Node2D

const IS_BOSS: bool = true
@onready var health_bar: HealthBar = $"../CanvasLayer/HealthBar"
@onready var hurt_sfx: AudioStreamPlayer2D = $Boss/hurtSFX
@onready var move_over: Timer = $moveOver
@onready var volley_timer: Timer = $moveOver/volleyTimer
@onready var wave_timer: Timer = $moveOver/volleyTimer/waveTimer
@onready var tell_timer: Timer = $moveOver/volleyTimer/waveTimer/tellTimer
@onready var space_player: CharacterBody2D = $"../spacePlayer"
@onready var rot_off: Node2D = $Boss/Sprite2D/RotOff
@onready var sprite_2d: Sprite2D = $Boss/Sprite2D/RotOff/Sprite2D
@onready var marker_2d: Marker2D = $Boss/Sprite2D/RotOff/Sprite2D/Marker2D
@onready var tell: CPUParticles2D = $Boss/Sprite2D/RotOff/Tell
@onready var animation_player: AnimationPlayer = $"../CanvasLayer/AnimationPlayer"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $Boss/Sprite2D/RotOff/Tell/AudioStreamPlayer2D
@onready var laser: AudioStreamPlayer2D = $Boss/hurtSFX/LASER

var movementAvailable = true
const bulletNorm = preload("res://scenes/bullet.tscn")
const tripleShot = preload("res://scenes/triple_shot.tscn")
const feathers = preload("res://scenes/feather_burst.tscn")
const sixteen = preload("res://scenes/16.tscn")
const PAIR = preload("res://scenes/pair.tscn")
var newMove = 0
var canShoot = false
var firstShot = true

func _ready() -> void:
	animation_player.connect("animation_finished", moveDone)

func _physics_process(delta: float) -> void:
	var playerPos = space_player.global_position - global_position
	rot_off.rotation = lerp_angle(rot_off.rotation, playerPos.angle(), 6.5*delta)

func takeDamage(dmg: float):
	GameManager.bossHealth -= dmg
	health_bar.changeValue(GameManager.bossHealth)
	hurt_sfx.play()
	if firstShot:
		move_over.start()
		firstShot = false
	if GameManager.bossHealth <= 0:
		GameManager.enemyCanAttack = false
		GameManager.playerCanMove = false
		space_player.isInvincible = true
		space_player.godModde = true
		animation_player.play("ded")
		
func _on_move_over_timeout() -> void:
	if GameManager.enemyCanAttack:
		print("TIME")
		randomize()
		newMove = randi_range(0, 5)
		
		if newMove == 0:
			telegraphAttack(1.5, superSpiralAttack)
		elif newMove == 1:
			telegraphAttack(1.5, followShotAttack)
		elif newMove == 2:
			telegraphAttack(1.5, featherShotgun2)
		elif newMove == 3:
			telegraphAttack(1.5, middle16)
		elif newMove == 4:
			telegraphAttack(1.5, tripleShotAttack)
		elif newMove == 5:
			if movementAvailable:
				animation_player.play("shmovement")
			move_over.start()

func superSpiralAttack():
	for i in range(50):
		laser.play()
		var newSpiral = PAIR.instantiate()
		newSpiral.global_position = marker_2d.global_position
		newSpiral.global_rotation = marker_2d.global_rotation
		get_tree().root.add_child(newSpiral)
		volley_timer.wait_time = 0.1
		volley_timer.start()
		await volley_timer.timeout
	print("STARTING SSA")

	move_over.start()

func followShotAttack():
	for i in range(15):
		laser.play()
		var newScene = bulletNorm.instantiate()
		var bullet_body = newScene.get_node("BulletBody")
		if bullet_body:
			bullet_body.speed = 1500
		newScene.global_position = marker_2d.global_position
		newScene.global_rotation = marker_2d.global_rotation
		get_tree().root.add_child(newScene)
		volley_timer.wait_time = 0.5
		volley_timer.start()
		await volley_timer.timeout
	print("STARTING FSA")

	move_over.start()

func featherShotgun2():
	for i in range(5):
		laser.play()
		var newFeathers = feathers.instantiate()
		newFeathers.global_position = marker_2d.global_position
		newFeathers.global_rotation = marker_2d.global_rotation
		get_tree().root.add_child(newFeathers)
		volley_timer.wait_time = 0.3
		volley_timer.start()
		await volley_timer.timeout
	print("STARTING FS")

	move_over.start()

func middle16():
	for i in range(16):
		laser.play()
		var new16 = sixteen.instantiate()
		new16.global_position = marker_2d.global_position
		new16.global_rotation = marker_2d.global_rotation + 0.5
		get_tree().root.add_child(new16)
		volley_timer.wait_time = 0.3
		volley_timer.start()
		await volley_timer.timeout
	print("STARTING m16")

	move_over.start()

func tripleShotAttack():
	for i in range(3):
		for j in range(3):
			laser.play()
			var newTriple = tripleShot.instantiate()
			newTriple.global_position = marker_2d.global_position
			newTriple.global_rotation = marker_2d.global_rotation
			get_tree().root.add_child(newTriple)
			volley_timer.wait_time = 0.3
			volley_timer.start()
			await volley_timer.timeout
		wave_timer.wait_time = 0.5
		volley_timer.start()
		await volley_timer.timeout
	print("STARTING TG")
	move_over.start()
	
func telegraphAttack(time, funct):
	audio_stream_player_2d.play()
	tell_timer.wait_time = time
	tell.emitting = true
	tell_timer.start()
	await tell_timer.timeout
	tell.emitting = false
	await tell.finished
	funct.call()
	
func moveDone():
	movementAvailable = true
