extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bullet_sprite: Sprite2D = $bulletSprite

var speed: float = 800.0
var hasCollided = false

func _physics_process(delta: float)-> void:
	global_position += Vector2(1, 0).rotated(rotation) * speed * delta

	if ray_cast_2d.is_colliding() and hasCollided == false:
		hasCollided = true
		bullet_sprite.visible = false
		
		if ray_cast_2d.get_collider().get("IS_PLAYER"):
			ray_cast_2d.get_collider().takeDamage()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "remove":
		queue_free()

func _on_distance_timeout_timeout() -> void:
	animation_player.play("remove")
