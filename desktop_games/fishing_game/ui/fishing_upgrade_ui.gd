extends VBoxContainer

@export var upgrade_name: String = ""
@export var property_name: String = ""
@export var tooltip: String = ""

@onready var upgrade_name_label: Label = %UpgradeNameLabel
@onready var upgrade_button: Button = %UpgradeButton
@onready var upgrade_level: ProgressBar = %UpgradeLevel
@onready var upgrade_value: Label = %UpgradeValue

@onready var tooltip_button: Button = %TooltipButton
@onready var tooltip_label: Label = %TooltipLabel

var upgrades_property_name: String
var costs_property_name: String

var current_upgrade_level: int = 0
var max_upgrade_level: int

func _ready() -> void:
	upgrades_property_name = property_name.to_upper() + "_UPGRADES"
	costs_property_name = property_name.to_upper() + "_COSTS"
	
	max_upgrade_level = DesktopManager.fishing_stats.get(upgrades_property_name).size()
	
	upgrade_name_label.text = upgrade_name
	
	if tooltip:
		tooltip_label.text = tooltip
		tooltip_button.mouse_entered.connect(func(): tooltip_label.visible = true)
		tooltip_button.mouse_exited.connect(func(): tooltip_label.visible = false)
	else:
		tooltip_button.visible = false
	
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	
	DesktopManager.fishing_money_changed.connect(sync_ui)
	
	sync_ui()

func _on_upgrade_button_pressed() -> void:
	var costs_array: Array[float] = DesktopManager.fishing_stats.get(costs_property_name)
	var upgrades_array: Array = DesktopManager.fishing_stats.get(upgrades_property_name)
	
	var cost: float = costs_array[current_upgrade_level]
	
	if DesktopManager.fishing_money >= cost:
		DesktopManager.fishing_stats.set(property_name, upgrades_array[current_upgrade_level])
		current_upgrade_level += 1
		DesktopManager.fishing_money -= cost

func sync_ui() -> void:
	var stat_value = DesktopManager.fishing_stats.get(property_name)
	upgrade_value.text = ("%.2f" if stat_value is float else "%d") % DesktopManager.fishing_stats.get(property_name)
	upgrade_level.max_value = max_upgrade_level
	upgrade_level.value = current_upgrade_level
	
	check_upgrade_button()

func check_upgrade_button() -> void:
	if current_upgrade_level >= max_upgrade_level:
		upgrade_button.text = "MAX"
		upgrade_button.disabled = true
		return
	
	var costs_array: Array[float] = DesktopManager.fishing_stats.get(costs_property_name)
	var cost: float = costs_array[current_upgrade_level]
	
	upgrade_button.text = "%.2f$" % cost
	upgrade_button.disabled = cost > DesktopManager.fishing_money
