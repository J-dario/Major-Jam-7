extends Node2D

@onready var shadow: Sprite2D = $shadow
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite

var speed: float = 200.0

func _physics_process(delta: float)-> void:
	global_position += Vector2(1, 0).rotated(rotation) * speed * delta
	shadow.position = Vector2(-2, 2).rotated(-rotation)
	sprite.rotation += 0.1
	if ray_cast_2d.is_colliding() and !ray_cast_2d.get_collider().get("IS_PLAYER"):
		animation_player.play("remove")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "remove":
		queue_free()

func _on_distance_timeout_timeout() -> void:
	animation_player.play("remove")
