extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"../player"

func _physics_process(delta: float) -> void:
	var playerPos = player.global_position - global_position
	if playerPos < Vector2.ZERO:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
