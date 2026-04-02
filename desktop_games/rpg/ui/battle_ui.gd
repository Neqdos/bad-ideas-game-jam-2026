extends Control

const ENEMY_UI = preload("uid://colmbgsekc27c")

@onready var enemy_button_conatiner: HBoxContainer = %EnemyButtonConatiner

@onready var health_bar: ProgressBar = %HealthBar
@onready var health_label: Label = %HealthLabel

@onready var mana_label: Label = %ManaLabel
@onready var mana_bar: ProgressBar = %ManaBar

@onready var hit_sfx: DesktopAudioPlayer = %HitSFX


func _ready() -> void:
	DesktopManager.rpg_start_battle.connect(_on_battle)
	DesktopManager.rpg_battle_ended.connect(_on_battle_ended)
	
	DesktopManager.turn_ended.connect(_on_turn_ended)

func _on_turn_ended() -> void:
	make_enemies_turn()
	hit_sfx.play()
	

func make_enemies_turn() -> void:
	await get_tree().process_frame
	for enemy: EnemyUI in enemy_button_conatiner.get_children():
		enemy.take_turn()
		await get_tree().create_timer(.5).timeout
	
	DesktopManager.can_attack = true

func _on_battle(battle: BattleResource) -> void:
	for enemy: EnemyResource in battle.enemies:
		var new_enemy_ui: EnemyUI = ENEMY_UI.instantiate()
		new_enemy_ui.enemy_resource = enemy
		enemy_button_conatiner.add_child(new_enemy_ui)
	
	DesktopManager.rpg_health = DesktopManager.rpg_max_health
	DesktopManager.can_attack = true
	visible = true

func _on_battle_ended() -> void:
	visible = false
