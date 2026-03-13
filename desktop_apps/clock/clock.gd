extends Control

@onready var time_label: Label = %TimeLabel
@onready var clock: TextureButton = %Clock
@onready var hour_line: ColorRect = %HourLine
@onready var minute_line: ColorRect = %MinuteLine

var changing_clock: bool = false

func _ready() -> void:
	clock.button_down.connect(_on_clock_button_down)
	clock.button_up.connect(_on_clock_button_up)

func _process(delta: float) -> void:
	var time: Dictionary = DesktopManager.get_time_dict()
	time_label.text = "%02d:%02d:%02d" % [time["hour"], time["minute"], time["second"]]
	
	minute_line.rotation = (time["minute"] + time["second"] / 60.0) / 60.0 * TAU
	hour_line.rotation = (time["hour"] + time["minute"] / 60.0) / 12.0 * TAU

func _on_clock_button_down() -> void:
	changing_clock = true

func _on_clock_button_up() -> void:
	changing_clock = false

func _input(event: InputEvent) -> void:
	if !changing_clock: return
	
	if event is InputEventMouseMotion:
		DesktopManager.time_minute_offset += event.relative.x
