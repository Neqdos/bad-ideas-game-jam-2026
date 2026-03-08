extends Node
class_name ObjectInteractAction

signal interacted(player: PlayerBody)
signal interaction_stopped()

@export var action_text: String = "Use"
@export_enum("object_interact", "object_move", "object_hold", "object_pick_up") var input_action_name: String = "object_interact"

var is_interacted: bool = false

func _ready() -> void:
	_base_ready()

func _base_ready() -> void:
	interacted.connect(func(player: PlayerBody): is_interacted = true)
	interaction_stopped.connect(func(): is_interacted = false)
