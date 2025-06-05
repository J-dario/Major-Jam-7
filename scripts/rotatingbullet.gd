extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bullet_sprite: Sprite2D = $bulletSprite
@onready var marker_2d: Marker2D = $".."
@onready var rotating_bullet: Node2D = $"../.."

var speed: float = 400.0
var hasCollided = false
var direction: Vector2

func _ready() -> void:
	direction = Vector2(1, 0).rotated(rotating_bullet.global_rotation)

func _physics_process(delta: float)-> void:
	rotating_bullet.global_position += direction * speed * delta
	marker_2d.rotation += 0.2
	
	if ray_cast_2d.is_colliding() and hasCollided == false:
		if ray_cast_2d.get_collider().get("IS_BOSS"):
			return
		hasCollided = true
		bullet_sprite.visible = false
		
		if ray_cast_2d.get_collider().get("IS_PLAYER"):
			ray_cast_2d.get_collider().takeDamage()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "remove":
		queue_free()

func _on_distance_timeout_timeout() -> void:
	animation_player.play("remove")
