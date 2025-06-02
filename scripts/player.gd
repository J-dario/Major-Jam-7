extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const MOVEMENT_SPEED: float = 500.0
const DODGE_SPEED: float = 800.0
const DODGE_DURATION: float = 0.3
const IS_PLAYER: bool = true

var dodgeRollDir: Vector2 = Vector2.ZERO
var dodgeRollTimer: float = 0.0
var isInvincible: bool = false

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if direction == 0:
		animated_sprite_2d.play("Idle")
	else:
		animated_sprite_2d.play("Run")

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
	velocity = lerp(velocity, input_vector * MOVEMENT_SPEED, 22.0 * delta)
	
	if Input.is_action_just_pressed("dodge"):
		if input_vector != Vector2.ZERO:
			dodgeRoll(input_vector)
		elif velocity.length() > 0.1:
			dodgeRoll(velocity.normalized())

func dodgeRoll(direction: Vector2) -> void:
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
		dodgeRollDir = Vector2.ZERO
		isInvincible = false
