extends Control

@onready var money_label: Label = %MoneyLabel

@onready var upgrades_container: ScrollContainer = %UpgradesContainer
@onready var items_container: ScrollContainer = %ItemsContainer

@onready var upgrades_tab_button: Button = %UpgradesTabButton
@onready var items_tab_button: Button = %ItemsTabButton

@onready var fish_compendium_button: Button = %FishCompendiumButton
@onready var shop_button: Button = %ShopButton
@onready var shop_menu: VBoxContainer = %ShopMenu
@onready var fish_compendium_menu: ScrollContainer = %FishCompendiumMenu

const DEFAULT_MONEY_LABEL_FONT_SIZE: float = 16.0
const EXPANDED_MONEY_LABEL_FONT_SIZE: float = 24.0
const EXPAND_MONEY_LABEL_TWEEN_TIME: float = .16

var tween: Tween

func _ready() -> void:
	DesktopManager.fishing_game_started.connect(_on_fishing_game_started)
	DesktopManager.fishing_game_ended.connect(_on_fishing_game_ended)
	
	DesktopManager.fishing_money_changed.connect(_on_money_changed)
	
	upgrades_tab_button.pressed.connect(func(): change_shop_tab(upgrades_container))
	items_tab_button.pressed.connect(func(): change_shop_tab(items_container))
	
	shop_button.pressed.connect(func(): change_menu(shop_menu))
	fish_compendium_button.pressed.connect(func(): change_menu(fish_compendium_menu))

func _on_fishing_game_started() -> void:
	visible = false

func _on_fishing_game_ended() -> void:
	visible = true

func _on_money_changed() -> void:
	money_label.text = "%.2f$" % DesktopManager.fishing_money
	
	money_label.set("theme_override_font_sizes/font_size", EXPANDED_MONEY_LABEL_FONT_SIZE)
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(money_label, "theme_override_font_sizes/font_size", DEFAULT_MONEY_LABEL_FONT_SIZE, EXPAND_MONEY_LABEL_TWEEN_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func change_shop_tab(to: Control) -> void:
	upgrades_container.visible = false
	items_container.visible = false
	
	to.visible = true

func change_menu(to: Control) -> void:
	shop_menu.visible = false
	fish_compendium_menu.visible = false
	
	to.visible = true
