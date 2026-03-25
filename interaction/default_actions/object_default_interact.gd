extends Node
class_name ObjectDefaultInteract

@export var player: PlayerBody
@onready var ray: InteractionRay = get_parent()

var interact_actions: Array[ObjectInteractAction]

func _ready() -> void:
	ray.hovered.connect(_on_ray_hovered)
	ray.unhovered.connect(_on_ray_unhovered)
	
	player.input.object_interact.connect(_on_object_interact)

func _on_ray_hovered() -> void:
	interact_actions.clear()
	
	for node: Node in ray.interactable.find_children("", "ObjectInteractAction", false): 
		if node is ObjectInteractAction:
			interact_actions.append(node)

func _on_ray_unhovered() -> void:
	for interact_action: ObjectInteractAction in interact_actions:
		if !is_instance_valid(interact_action): continue
		if interact_action.is_interacted and interact_action.is_inside_tree():
			interact_action.interaction_stopped.emit()
	interact_actions.clear()

func _on_object_interact(released: bool) -> void:
	if !is_instance_valid(ray.interactable): return
	
	for action: ObjectInteractAction in interact_actions:
		if !is_instance_valid(action): continue
		if released:
			action.interaction_stopped.emit()
		else:
			action.interacted.emit(player)
