extends Node3D

@onready var object_interact_action: ObjectInteractAction = %ObjectInteractAction
@onready var moving_platform: MovingPlatform = %MovingPlatform

func _ready() -> void:
	object_interact_action.interacted.connect(func(player: PlayerBody): moving_platform.move())
