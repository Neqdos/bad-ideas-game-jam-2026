extends Control

@onready var message_container: VBoxContainer = %MessageContainer

const MESSAGE_BOX_SCENE = preload("uid://dj0qu8lrw1h85")

const MAX_MESSAGE_COUNT: int = 8

func _ready() -> void:
	SignalManager.send_message.connect(_on_send_message)

func _on_send_message(text: String) -> void:
	var kill_last_message: bool = false
	if message_container.get_child_count() >= MAX_MESSAGE_COUNT: kill_last_message = true
	
	for mb: MessageBox in message_container.get_children():
		if mb.is_dying: continue
		if kill_last_message:
			kill_last_message = false
			mb.death()
			continue
		mb.fade_effect()
	
	var new_message_box: MessageBox = MESSAGE_BOX_SCENE.instantiate()
	new_message_box.message = text
	
	message_container.add_child(new_message_box)
