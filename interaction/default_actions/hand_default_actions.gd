extends Node
class_name HandDefaultActions

@export var player: PlayerBody

@onready var ray: InteractionRay = get_parent()

var hand_interact_actions: Array[HandInteractAction]
var node_cooldowns: Array[HandInteractAction]

func _ready() -> void:
	player.inv_manager.held_object_changed.connect(_on_held_object_changed)
	
	player.input.interact.connect(_on_interact)
	
	player.input.throw.connect(_on_throw)

func _on_held_object_changed() -> void:
	hand_interact_actions.clear()
	if !is_instance_valid(player.inv_manager.held_object): return
	
	for node: Node in player.inv_manager.held_object.find_children("", "HandInteractAction", false):
		if node is HandInteractAction:
			hand_interact_actions.append(node)

func _on_interact(action_type: String, released: bool) -> void:
	if !is_instance_valid(player.inv_manager.held_object): return
	
	for interact_action: HandInteractAction in hand_interact_actions:
		if interact_action.input_action_name != action_type: continue
		if !released:
			_apply_interacted(interact_action)
		elif interact_action.is_interacted:
			interact_action.interaction_stopped.emit()

func _on_throw() -> void:
	if !is_instance_valid(player.inv_manager.held_object): return
	
	var previously_held_object: RigidObject = player.inv_manager.held_object
	
	player.inv_manager.unhold_object()
	StorageMethods.throw_object(previously_held_object, -ray.global_basis.z, ray.global_position)

func _apply_interacted(interact_action: HandInteractAction) -> void:
	if node_cooldowns.has(interact_action): return
	if !is_instance_valid(player.inv_manager.held_object) or interact_action.get_parent() != player.inv_manager.held_object: return
	
	node_cooldowns.append(interact_action)
	interact_action.interacted.emit(player.inv_manager.player)
	
	await get_tree().create_timer(interact_action.cooldown_amount).timeout
	
	if !is_instance_valid(interact_action): return
	
	node_cooldowns.erase(interact_action)
	
	if interact_action.hold_to_use and interact_action.is_interacted:
		_apply_interacted(interact_action)
