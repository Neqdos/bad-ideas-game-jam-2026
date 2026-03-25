extends StaticBody3D

@export var electromagnet: Electromagnet

@onready var object_interact_action: ObjectInteractAction = %ObjectInteractAction


var used: bool = false

func _ready() -> void:
	object_interact_action.interacted.connect(_on_object_interact_action_interacted)

func _on_object_interact_action_interacted(player: PlayerBody) -> void:
	if used: return
	used = true
	electromagnet.move()
