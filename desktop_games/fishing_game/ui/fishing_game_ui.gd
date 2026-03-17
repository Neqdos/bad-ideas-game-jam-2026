extends Control

@onready var money_label: Label = %MoneyLabel

func _ready() -> void:
	DesktopManager.fishing_game_started.connect(_on_fishing_game_started)
	DesktopManager.fishing_game_ended.connect(_on_fishing_game_ended)
	
	DesktopManager.fishing_money_changed.connect(_on_money_changed)

func _on_fishing_game_started() -> void:
	visible = false

func _on_fishing_game_ended() -> void:
	visible = true

func _on_money_changed() -> void:
	money_label.text = "%.2f$" % DesktopManager.fishing_money
