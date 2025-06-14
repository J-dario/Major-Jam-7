extends Line2D

var length = 20
var point = Vector2()

func _process(delta: float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	
	point = get_parent().global_position
	
	add_point(point)
	while get_point_count() > length:
		remove_point(0)
