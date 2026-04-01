extends Control

@onready var enemy_sprite_button: TextureButton = %EnemySpriteButton
@onready var enemy_health_bar: ProgressBar = %EnemyHealthBar

var enemy_resource: EnemyResource

var max_health: int
var health: int

var current_action: int = 0

func _ready() -> void:
	health = enemy_resource.health
	max_health = enemy_resource.health
	
	enemy_sprite_button.texture_normal = enemy_resource.sprite
	enemy_health_bar.max_value = max_health
	enemy_health_bar.value = health

func take_turn() -> void:
	match enemy_resource.actions.keys()[current_action]:
		enemy_resource.ACTION_TYPE.Attack:
			DesktopManager.rpg_health -= enemy_resource.actions[current_action]
		enemy_resource.ACTION_TYPE.Wait:
			pass
		enemy_resource.ACTION_TYPE.Heal:
			health += enemy_resource.actions[current_action]
			health = mini(health, max_health)

func damage(amount: int) -> void:
	pass
