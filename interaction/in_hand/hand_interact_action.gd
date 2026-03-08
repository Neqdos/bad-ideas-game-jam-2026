extends Node
class_name HandInteractAction

signal interacted(player: PlayerBody)
signal interaction_stopped()

@export_enum("interact_primary", "interact_secondary") var input_action_name: String = "interact_primary"

@export var hold_to_use: bool = false
@export var cooldown_amount: float

var is_interacted: bool = false

func _ready() -> void:
	_base_ready()

func _base_ready() -> void:
	interacted.connect(func(player: PlayerBody): is_interacted = true)
	interaction_stopped.connect(func(): is_interacted = false)
