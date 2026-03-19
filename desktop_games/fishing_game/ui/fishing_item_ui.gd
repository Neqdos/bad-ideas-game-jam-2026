extends VBoxContainer

@export var item_name: String = ""
@export var item_scene: PackedScene
@export var cost: float = 0.0
@export var tooltip: String = ""

@onready var item_name_label: Label = %ItemNameLabel
@onready var buy_button: Button = %BuyButton
@onready var tooltip_button: Button = %TooltipButton
@onready var tooltip_label: Label = %TooltipLabel

var is_bought: bool = false

func _ready() -> void:
	if tooltip:
		tooltip_label.text = tooltip
		tooltip_button.mouse_entered.connect(func(): tooltip_label.visible = true)
		tooltip_button.mouse_exited.connect(func(): tooltip_label.visible = false)
	else:
		tooltip_button.visible = false
	
	item_name_label.text= item_name
	buy_button.text = "%.2f$" % cost
	
	buy_button.pressed.connect(_on_buy_button_pressed)
	
	DesktopManager.fishing_money_changed.connect(sync_ui)
	DesktopManager.fishing_game_started.connect(_on_fishing_game_started)
	
	sync_ui()

func _on_buy_button_pressed() -> void:
	if DesktopManager.fishing_money >= cost:
		is_bought = true
		var new_item: FishingItem = item_scene.instantiate()
		DesktopManager.fishing_hook.add_child(new_item)
		DesktopManager.fishing_money -= cost

func _on_fishing_game_started() -> void:
	is_bought = false
	sync_ui()

func sync_ui() -> void:
	if is_bought:
		buy_button.disabled = true
		return
	
	buy_button.disabled = cost > DesktopManager.fishing_money
