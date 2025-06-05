extends Node2D
@onready var parallax_background: ParallaxBackground = $ParallaxBackground

@export var scollingSpeed = 400

func _process(delta: float) -> void:
	parallax_background.scroll_offset.x -= scollingSpeed*delta
