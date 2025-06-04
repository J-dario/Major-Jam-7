extends Camera2D

var desiredOffset: Vector2
var minOffset = -150
var maxOffset = 150


var shakeIntensity: float = 0.0
var activeShakeTime: float = 0.0
var shakeDecay: float = 5.0
var shakeTime: float = 0.0
var shakeTimeSpeed: float = 20.0
var noise = FastNoiseLite.new()

func _process(delta: float) -> void:
	desiredOffset = (get_global_mouse_position()/2 - position)*0.5
	desiredOffset.x = clamp(desiredOffset.x, minOffset, maxOffset)
	desiredOffset.y = clamp(desiredOffset.y, minOffset / 2.0, maxOffset / 2.0)
	
	global_position = get_parent().global_position + desiredOffset

func _physics_process(delta: float) -> void:
	if activeShakeTime > 0:
		shakeTime += delta * shakeTimeSpeed
		activeShakeTime -= delta
		
		offset = Vector2(
			noise.get_noise_2d(shakeTime, 0) * shakeIntensity,
			noise.get_noise_2d(0, shakeTime) * shakeIntensity
		)
		
		shakeIntensity = max(shakeIntensity - shakeDecay * delta, 0)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5*delta)

func screen_shake(intensity: int, time: float):
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	
	shakeIntensity = intensity
	activeShakeTime = time
	shakeTime = 0.0
