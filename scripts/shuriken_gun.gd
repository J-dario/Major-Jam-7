extends Node2D

const bulletScene = preload("res://scenes/shurikenBullet.tscn")

@onready var rotationOffset: Node2D = $RotationOffset
@onready var shootPos: Marker2D = $RotationOffset/Sprite2D/shootPos
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var timeBetweenShots: float = 0.25
var canShoot: bool = true

func _ready() -> void:
	$shootTimer.wait_time = timeBetweenShots

func _physics_process(delta: float) -> void:
	rotationOffset.rotation = lerp_angle(rotationOffset.rotation, (get_global_mouse_position() - global_position).angle(), 6.5*delta)

	if DialogManager.is_active == true:
		return
		
	if Input.is_action_just_pressed("shoot") and canShoot:
		_shoot()
		canShoot = false
		$shootTimer.start()

func _shoot():
	audio_stream_player_2d.play()
	var newBullet = bulletScene.instantiate()
	get_tree().root.add_child(newBullet)
	newBullet.global_position = shootPos.global_position
	newBullet.global_rotation = shootPos.global_rotation

func _on_shoot_timer_timeout() -> void:
	canShoot = true
