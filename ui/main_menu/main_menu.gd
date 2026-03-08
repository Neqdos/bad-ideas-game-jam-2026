extends Control

const GAME_SCENE = preload("uid://eilrpbiqfcoc")

@onready var start_game_button: Button = %StartGameButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	start_game_button.pressed.connect(_on_start_game_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
