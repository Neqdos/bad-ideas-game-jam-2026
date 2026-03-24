extends RigidObject
class_name Battery

@onready var hand_interact_action: HandInteractAction = %HandInteractAction

var battery_slot: BatterySlot

func _ready() -> void:
	hand_interact_action.interacted.connect(_on_interacted)

func _on_interacted(player: PlayerBody) -> void:
	if !is_instance_valid(player.player_interaction_ray.interactable): return
	
	var interactable = player.player_interaction_ray.interactable
	
	if interactable is BatterySlot:
		interactable.insert_battery(self)
