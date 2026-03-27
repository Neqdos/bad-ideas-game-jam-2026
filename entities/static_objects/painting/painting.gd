extends Node3D

@export var pos_correct: float
@export var pos_incorrect: float

@onready var painting_paint: PaintingPaint = %PaintingPaint

var tween: Tween

var was_correct: bool = false

func _ready() -> void:
	painting_paint.correct_paint.connect(_on_correct_paint)
	painting_paint.incorrect_paint.connect(_on_incorrect_paint)

func _on_correct_paint() -> void:
	if was_correct: return
	was_correct = true
	
	if tween: tween.kill()
	
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position:y", pos_correct, 2.0)

func _on_incorrect_paint() -> void:
	if !was_correct: return
	was_correct = false
	
	if tween: tween.kill()
	
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position:y", pos_incorrect, 2.0)
