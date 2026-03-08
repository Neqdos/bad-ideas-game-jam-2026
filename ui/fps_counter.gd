extends Label

func _process(delta: float) -> void:
	text = str(roundf(1.0 / delta))
