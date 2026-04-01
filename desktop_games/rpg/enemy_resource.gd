extends Resource
class_name EnemyResource

@export var sprite: Texture2D
@export var health: int
@export var actions: Dictionary[ACTION_TYPE, int]


enum ACTION_TYPE {
	Attack,
	Wait,
	Heal,
}
