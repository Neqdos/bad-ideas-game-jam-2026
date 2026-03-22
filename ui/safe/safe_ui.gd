extends Control

@onready var safe_dingle_button: TextureButton = %SafeDingleButton
@onready var safe_dingle: TextureRect = %SafeDingle

@onready var safe_digit_1: SafeDigit = %SafeDigit1
@onready var safe_digit_2: SafeDigit = %SafeDigit2
@onready var safe_digit_3: SafeDigit = %SafeDigit3
@onready var safe_digit_4: SafeDigit = %SafeDigit4

var tween: Tween

var can_press: bool = true

func _ready() -> void:
	safe_dingle_button.pressed.connect(_on_safe_dingle_button_pressed)
	
	DesktopManager.safe_ui_open.connect(_open)

func _on_safe_dingle_button_pressed() -> void:
	if !can_press: return
	can_press = false
	
	var safe_code: String = "%d%d%d%d" % [safe_digit_1.digit, safe_digit_2.digit, safe_digit_3.digit, safe_digit_4.digit]
	
	if DesktopManager.safe_code == safe_code:
		tween = get_tree().create_tween()
		tween.tween_property(safe_dingle, "rotation_degrees", 90.0, .6)
		
		await tween.finished
		
		DesktopManager.safe_opened.emit()
		_close()
	else:
		tween = get_tree().create_tween()
		tween.tween_property(safe_dingle, "rotation_degrees", 30.0, .2)
		tween.tween_property(safe_dingle, "rotation_degrees", 0.0, .2)
		
		await tween.finished
		
		can_press = true

func _unhandled_input(event: InputEvent) -> void:
	if !visible: return
	if event.is_action_pressed("esc"):
		_close()


func _open() -> void:
	visible = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalManager.camera_lock.emit(true)
	SignalManager.player_input_lock.emit(true)

func _close() -> void:
	visible = false
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalManager.camera_lock.emit(false)
	SignalManager.player_input_lock.emit(false)
