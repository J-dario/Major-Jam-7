extends Node2D

func _physics_process(delta: float)-> void:
	global_position += Vector2(1, 0).rotated(rotation) * 800 * delta
