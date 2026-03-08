extends Control
class_name MessageBox

@onready var message_text: Label = %MessageText

const MESSAGE_TIME: float = 3.0

var tween: Tween

var can_fade: bool = true
var is_dying: bool = false

var message: String


func _ready() -> void:
	message_text.text = message
	message_text.size.x = 0.0
	
	await get_tree().process_frame
	
	message_text.position.x = -48.0
	
	tween = get_tree().create_tween()
	tween.tween_property(message_text, "position:x", 0.0, 1.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	await get_tree().create_timer(MESSAGE_TIME).timeout
	
	death()

func death() -> void:
	if is_dying: return
	is_dying = true
	can_fade = false
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, .5)
	
	await tween.finished
	
	queue_free()

func fade_effect() -> void:
	if !can_fade: return
	can_fade = false
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", .5, .5)
