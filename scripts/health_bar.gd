extends ProgressBar
class_name HealthBar

var changeValueTween: Tween
var opacity_tween: Tween

func _setup_health_bar(maxVal: float):
	value = maxVal
	max_value = maxVal
	$insideBar.value = maxVal
	$insideBar.max_value = maxVal
	
func changeValue(newValue: float):
	_changeOpacity(1.0)
	# await opacity_tween.finished
	value = newValue
	
	if changeValueTween:
		changeValueTween.kill()
	changeValueTween = create_tween()
	changeValueTween.tween_property($insideBar, "value", newValue, 0.35).set_trans(Tween.TRANS_SINE)

func _changeOpacity(newAmount: float):
	if opacity_tween:
		opacity_tween.kill()
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, "modulate:a", newAmount, 0.12).set_trans(Tween.TRANS_SINE)
