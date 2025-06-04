extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shuriken: Node2D = $Shuriken
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2
@onready var cpu_particles_2d_3: CPUParticles2D = $CPUParticles2D3
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var audio_stream_player_2d_3: AudioStreamPlayer2D = $AudioStreamPlayer2D3
@onready var player_health_bar: PlayerHealthBar = $"../CanvasLayer/PlayerHealthBar"
@onready var camera_2d: Camera2D = $Camera2D
@onready var audio_stream_player_2d_4: AudioStreamPlayer2D = $AudioStreamPlayer2D4
@onready var color_rect: ColorRect = $"../CanvasLayer/ColorRect"
@onready var PICKUP_COIN__3_ = preload("res://sounds/pickupCoin (3).wav")

const DODGE_SPEED: float = 800.0
const DODGE_DURATION: float = 0.3
const IS_PLAYER: bool = true

var footStepsPlaying = false
var dodgeRollDir: Vector2 = Vector2.ZERO
var dodgeRollTimer: float = 0.0
var isInvincible: bool = false

func freeze_frame(timescale: float, duration: float) -> void:
	Engine.time_scale = timescale
	color_rect.visible = true
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
	color_rect.visible = false
	
func takeDamage():
	if !isInvincible:
		player_health_bar.takeDMG()
		$AnimationPlayer.play("hit")
		camera_2d.screen_shake(15, 0.8)
		audio_stream_player_2d_4.play()
		freeze_frame(0.2, 0.3)

func _physics_process(delta: float) -> void:
	if (get_global_mouse_position() - global_position) < Vector2.ZERO:
		animated_sprite_2d.flip_h = true
		shuriken.position.x = -25
	else:
		animated_sprite_2d.flip_h = false
		shuriken.position.x = 25
	
	if DialogManager.is_active == true:
		return
		
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	if input_vector != Vector2.ZERO:
		cpu_particles_2d.emitting = true
		animated_sprite_2d.play("Run")
		
		if footStepsPlaying == false:
			footStepsPlaying = true
			audio_stream_player_2d.play()
	else:
		animated_sprite_2d.play("Idle")

	if dodgeRollTimer > 0.0:
		_dodgeLogic(delta)
	else:
		_movement(delta)
	move_and_slide()

func _movement(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	# chane 22 to increase/decrease acceleration
	velocity = lerp(velocity, input_vector * GameManager.movementSpeed, 22.0 * delta)
	
	if Input.is_action_just_pressed("dodge"):
		if input_vector != Vector2.ZERO:
			dodgeRoll(input_vector)
		elif velocity.length() > 0.1:
			dodgeRoll(velocity.normalized())

func dodgeRoll(direction: Vector2) -> void:
	cpu_particles_2d_2.emitting = true
	audio_stream_player_2d_2.play()
	dodgeRollDir = direction
	dodgeRollTimer = DODGE_DURATION
	isInvincible = true
	
	$AnimationPlayer.speed_scale = 1.0 / DODGE_DURATION
	$AnimationPlayer.play("rollLeft" if direction.x < 0 else "rollRight")

func _dodgeLogic(delta: float) -> void:
	var elapsed_percent = 1.0 - (dodgeRollTimer / DODGE_DURATION)
	var current_speed = lerp(DODGE_SPEED, DODGE_SPEED * 0.5, elapsed_percent)
	
	velocity = dodgeRollDir * current_speed
	dodgeRollTimer -= delta
	if dodgeRollTimer <= 0.0:
		cpu_particles_2d_3.emitting = true
		audio_stream_player_2d_3.play()
		dodgeRollDir = Vector2.ZERO
		isInvincible = false

func _on_audio_stream_player_2d_finished() -> void:
	footStepsPlaying = false


func _on_audio_stream_player_2d_4_finished() -> void:
	if GameManager.currentHealth == 0:
			GameManager.playerDed()
