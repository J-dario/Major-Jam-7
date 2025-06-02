extends Camera2D

var desiredOffset: Vector2
var minOffset = -100
var maxOffset = 100

func _process(delta: float) -> void:
	desiredOffset = (get_global_mouse_position()/3 - position)*0.5
	desiredOffset.x = clamp(desiredOffset.x, minOffset, maxOffset)
	desiredOffset.y = clamp(desiredOffset.y, minOffset / 2.0, maxOffset / 2.0)
	
	global_position = get_parent().global_position + desiredOffset
