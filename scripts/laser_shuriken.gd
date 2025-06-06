extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var laser_player: AnimationPlayer = $laserPlayer

var speed: float = 800.0
var hasCollided = false

func _physics_process(delta: float)-> void:
	global_position += Vector2(1, 0).rotated(rotation) * speed * delta
	sprite.rotation += 0.2

	if ray_cast_2d.is_colliding() and !hasCollided:
		var collider = ray_cast_2d.get_collider()
		if collider != null and not collider.get("IS_PLAYER"):
			hasCollided = true
			cpu_particles_2d.emitting = true;
			audio_stream_player_2d.play()
			sprite.visible = false
			line_2d.visible = false
			
			print(ray_cast_2d.get_collider())
			if ray_cast_2d.get_collider().get("IS_BOSS"):
				ray_cast_2d.get_collider().takeDamage(GameManager.playerDamage)

func _on_cpu_particles_2d_finished() -> void:
	queue_free()

func _on_distance_timeout_timeout() -> void:
	laser_player.play("laserRemove")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "laserRemove":
		queue_free()
