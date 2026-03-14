extends Control

@onready var time_label: Label = %TimeLabel
@onready var clock: TextureButton = %Clock
@onready var hour_line: ColorRect = %HourLine
@onready var minute_line: ColorRect = %MinuteLine

var changing_clock: bool = false

var rot_vector: Vector2

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
	set_rot_vector()

func _on_clock_button_up() -> void:
	changing_clock = false

func _input(event: InputEvent) -> void:
	if !changing_clock: return
	
	if event is InputEventMouseMotion:
		var old_rot_vector: Vector2 = rot_vector
		set_rot_vector()
		DesktopManager.time_minute_offset -= rot_vector.angle_to(old_rot_vector) / TAU * 60.0

func set_rot_vector() -> void:
	rot_vector = (get_global_mouse_position() - size / 2.0).normalized()
