extends Node2D

@onready var bomb_file_tile: FileTile = %BombFileTile
@onready var holyfish_file_tile: FileTile = %HolyfishFileTile
@onready var explosion: DesktopAudioPlayer = %Explosion
@onready var gate_tilemap: TileMapLayer = %GateTilemap
@onready var rpg_player: RPGPlayer = %RPGPlayer

@onready var music: DesktopAudioPlayer = %Music
@onready var battle_music: DesktopAudioPlayer = %BattleMusic
@onready var victor: Area2D = %Victor
@onready var victor_sprite: VictorSprite = %VictorSprite

func _ready() -> void:
	bomb_file_tile.file_placed.connect(_on_bomb_placed)
	holyfish_file_tile.file_placed.connect(_on_holyfish_placed)
	
	victor.body_entered.connect(_on_victor_body_entered)
	
	DesktopManager.rpg_start_battle.connect(func(battle):
		music.stream_paused = true
		battle_music.play())
	DesktopManager.rpg_battle_ended.connect(func():
		music.stream_paused = false
		battle_music.stop())

func _on_victor_body_entered(body: Node2D) -> void:
	if body is RPGPlayer:
		victor_sprite.death()
		victor.queue_free.call_deferred()
		await victor_sprite.died
		DesktopManager.victors_defeated += 1

func _on_bomb_placed() -> void:
	bomb_file_tile.queue_free.call_deferred()
	gate_tilemap.enabled = false
	explosion.play()

func _on_holyfish_placed() -> void:
	holyfish_file_tile.queue_free.call_deferred()
	DesktopManager.rpg_flying = true
	rpg_player.set_collision_mask_value(4, false)
