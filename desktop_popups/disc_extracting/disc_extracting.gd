extends Control

@export var noise: FastNoiseLite

@onready var progress_bar: ProgressBar = %ProgressBar

@onready var extracting_label: Label = %ExtractingLabel
@onready var extracting_label_dot_timer: Timer = %ExtractingLabelDotTimer

const NOISE_VALUE_MULT: float = 1.0
const NOISE_VALUE_OFFSET: float = 0.0
const TIME_SCALE: float = 10.0

var dot_count: int = 0

var extracting: bool = true

var total_time: float

var data: Dictionary[String, Variant]

var file_res: FileResource
var label_text: String

func _ready() -> void:
	extracting_label_dot_timer.timeout.connect(_on_extracting_label_dot_timer_timeout)
	
	noise.seed = randi()
	progress_bar.value = 0.0
	total_time = 0.0
	
	file_res = data["file_res"]
	if data["type"] == 1:
		label_text = "DOWNLOADING FILE"
	else:
		label_text = "EXTRACTING FILE"


func _on_extracting_label_dot_timer_timeout() -> void:
	if !extracting: return
	
	var dots: String = ""
	for i: int in range(dot_count): dots += "."
	
	extracting_label.text = "%s\n%s" % [label_text, dots]
	dot_count = (dot_count + 1) % 4

func _process(delta: float) -> void:
	if !extracting: return
	
	total_time += delta * TIME_SCALE
	
	var val: float = max((noise.get_noise_1d(total_time) + NOISE_VALUE_OFFSET) * NOISE_VALUE_MULT, 0.0)
	progress_bar.value += val
	
	if is_equal_approx(progress_bar.value, progress_bar.max_value):
		extracting = false
		var popup_window: PopupWindow = GlobalMethods.find_first_parent_of_type(self, PopupWindow)
		if is_instance_valid(popup_window): popup_window.close_button.visible = true
		DesktopManager.disc_extracting_finished.emit()
		DesktopManager.add_file_to_desktop(file_res)
		extracting_label.text = "%s COMPLETED." % label_text
