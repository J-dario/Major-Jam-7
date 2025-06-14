extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite
@onready var line_2d: Line2D = $Line2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var camera_2d: Camera2D = $/root/Node2D/player/Camera2D

var speed: float = 800.0
var hasCollided = false

func _physics_process(delta: float)-> void:
	global_position += Vector2(1, 0).rotated(rotation) * speed * delta
	sprite.rotation += 0.2
	
	if ray_cast_2d.is_colliding() and !ray_cast_2d.get_collider().get("IS_PLAYER") and hasCollided == false:
		hasCollided = true
		cpu_particles_2d.emitting = true;
		audio_stream_player_2d.play()
		sprite.visible = false
		line_2d.visible = false
		camera_2d.screen_shake(4, 0.1)
		
		if ray_cast_2d.get_collider().get("IS_BOSS"):
			ray_cast_2d.get_collider().takeDamage(GameManager.playerDamage)
			camera_2d.screen_shake(8, 0.3)

func _on_cpu_particles_2d_finished() -> void:
	queue_free()


func _on_distance_timeout_timeout() -> void:
	animation_player.play("remove")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "remove":
		queue_free()
