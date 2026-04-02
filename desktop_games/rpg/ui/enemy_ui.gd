extends Control
class_name EnemyUI

@onready var enemy_health_bar: ProgressBar = %EnemyHealthBar
@onready var enemy_sprite: TextureRect = %EnemySprite
@onready var click_detection: TextureButton = %ClickDetection


var enemy_resource: EnemyResource

var max_health: int
var health: int:
	set(val):
		health = val
		enemy_health_bar.value = val

var current_action: int = 0

func _ready() -> void:
	health = enemy_resource.health
	max_health = enemy_resource.health
	
	enemy_sprite.texture = enemy_resource.sprite
	enemy_health_bar.max_value = max_health
	enemy_health_bar.value = health
	
	click_detection.pressed.connect(_on_sprite_button_pressed)
	
	DesktopManager.rpg_battle_enemies += 1

func take_turn() -> void:
	match enemy_resource.actions.keys()[current_action]:
		enemy_resource.ACTION_TYPE.Attack:
			DesktopManager.rpg_health -= enemy_resource.actions[current_action]
		enemy_resource.ACTION_TYPE.Wait:
			pass
		enemy_resource.ACTION_TYPE.Heal:
			health += enemy_resource.actions[current_action]
			health = mini(health, max_health)


func _on_sprite_button_pressed() -> void:
	if !DesktopManager.can_attack: return
	DesktopManager.can_attack = false
	
	health -= 1
	
	if health <= 0:
		DesktopManager.rpg_battle_enemies -= 1
		if DesktopManager.rpg_battle_enemies <= 0:
			DesktopManager.rpg_battle_ended.emit()
		queue_free.call_deferred()
	
	DesktopManager.turn_ended.emit()
