extends Control
class_name TextFileScene

@onready var text_data: TextEdit = %TextData

var data: String

func _ready() -> void:
	text_data.text = data
