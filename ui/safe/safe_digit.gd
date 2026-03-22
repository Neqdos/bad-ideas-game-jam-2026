extends VBoxContainer
class_name SafeDigit

@onready var digit_up: Button = %DigitUp
@onready var digit_label: Label = %DigitLabel
@onready var digit_down: Button = %DigitDown

var digit: int = 0:
	set(val):
		if val > 9:
			digit = 0
		elif val < 0:
			digit = 9
		else:
			digit = val
		digit_label.text = str(digit)

func _ready() -> void:
	digit_up.pressed.connect(func(): digit += 1)
	digit_down.pressed.connect(func(): digit -= 1)
