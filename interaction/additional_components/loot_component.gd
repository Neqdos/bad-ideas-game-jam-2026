extends Node
class_name LootComponent

@export var parent_object: RigidObject

@export var loot: Array[LootResource]

func _ready() -> void:
	var health_component: HealthComponent = get_parent()
	health_component.died.connect(_select_loot)

func _select_loot() -> void:
	var loot_to_value: Dictionary[LootResource, float]
	var sum: float = 0.0
	
	for loot_resource: LootResource in loot:
		sum += loot_resource.sao_paulo
		loot_to_value[loot_resource] = sum
	
	if sum > 1.0: push_error("The sum of loot exceeds 1.0 %s" % parent_object.name)
	
	
	var random: float = randf()
	
	for loot_resource: LootResource in loot_to_value:
		if random <= loot_to_value[loot_resource]:
			_create_loot(loot_resource)
			return

func _create_loot(loot_resource: LootResource) -> void:
	var objects_node: Node3D = get_tree().get_first_node_in_group("objects_node")
	
	var amount: int = randi_range(loot_resource.min_amount, loot_resource.max_amount)
	
	for i: int in amount:
		var new_object: RigidObject = loot_resource.object_scene.instantiate()
		objects_node.add_child(new_object)
		new_object.global_position = parent_object.global_position
	
