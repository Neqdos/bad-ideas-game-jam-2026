extends RigidObject

@export var model: Node3D

@onready var hand_interact_action: HandInteractAction = %HandInteractAction

var tween: Tween

func _ready() -> void:
	hand_interact_action.interacted.connect(_on_interacted)

func _on_interacted(player: PlayerBody) -> void:
	play_default_animation()
	
	if !is_instance_valid(player.player_interaction_ray.interactable): return
	
	var interactable: Node3D = player.player_interaction_ray.interactable
	if interactable.name == "WindowBody":
		var door: WindowDoor = interactable.get_parent()
		door.destroy_window()

func play_default_animation() -> void:
	if tween: tween.stop()
	
	model.rotation.x = -PI / 3
	tween = get_tree().create_tween()
	tween.tween_property(model, "rotation:x", 0.0, .24).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
