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

const bulletScene = preload("res://scenes/bullet.tscn")
const tripleShot = preload("res://scenes/triple_shot.tscn")
const pair = preload("res://scenes/pair.tscn")
const feathers = preload("res://scenes/feather_burst.tscn")
const sixteen = preload("res://scenes/16.tscn")

var newMove = 0
var canShoot = false
var firstShot = true

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
		
func _on_move_over_timeout() -> void:
	randomize()
	newMove = randi_range(0, 1)
	
	if newMove == 0:
		telegraphAttack(2, tripleShotAttack)
	elif newMove == 1:
		telegraphAttack(2, followShotAttack)

func followShotAttack():
	move_over.wait_time = 5
	move_over.start()
	while(move_over.wait_time != 0):
		pass

func superSpiralAttack():
	pass

func featherShotgun2():
	pass

func middle16():
	pass

func tripleShotAttack():
	for i in range(3):
		for j in range(3):
			var newTriple = pair.instantiate()
			newTriple.global_position = marker_2d.global_position
			newTriple.global_rotation = marker_2d.global_rotation
			get_tree().root.add_child(newTriple)
			volley_timer.wait_time = 0.3
			volley_timer.start()
			await volley_timer.timeout
		wave_timer.wait_time = 0.5
		volley_timer.start()
		await volley_timer.timeout
	move_over.start()
	
func telegraphAttack(time, funct):
	tell_timer.wait_time = time
	tell.emitting = true
	tell_timer.start()
	await tell_timer.timeout
	tell.emitting = false
	await tell.finished
	funct.call()
