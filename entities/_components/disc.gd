extends RigidObject
class_name Disc

@export var file_res: FileResource
@export var interact_action: HandInteractAction

var used: bool = false

func _ready() -> void:
	interact_action.interacted.connect(_on_interacted)

func _on_interacted(player: PlayerBody) -> void:
	if used:
		SignalManager.send_message.emit("This USB drive was already used.")
		return
	
	if !is_instance_valid(player.player_interaction_ray.interactable): return
	
	var interactable: Node3D = player.player_interaction_ray.interactable
	if interactable is DiscSlot:
		if !interactable.is_empty:
			SignalManager.send_message.emit("USB slot is in use.")
			return
		interactable.insert(self)
		used = true
