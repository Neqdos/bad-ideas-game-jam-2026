extends AnimatableBody3D
class_name Book

@export var type: BOOK_TYPE
@export var bookshelf: Bookshelf

@export var default_pos_z: float
@export var pushed_pos_z: float

@onready var object_interact_action: ObjectInteractAction = %ObjectInteractAction

@onready var book_red: MeshInstance3D = %BookRed
@onready var book_green: MeshInstance3D = %BookGreen
@onready var book_purple: MeshInstance3D = %BookPurple
@onready var book_yellow: MeshInstance3D = %BookYellow
@onready var book_blue: MeshInstance3D = %BookBlue

enum BOOK_TYPE {
	Red,
	Green,
	Purple,
	Yellow,
	Blue
}

@onready var book_type_to_mesh: Dictionary[BOOK_TYPE, MeshInstance3D] = {
	BOOK_TYPE.Red : book_red,
	BOOK_TYPE.Green : book_green,
	BOOK_TYPE.Purple : book_purple,
	BOOK_TYPE.Yellow : book_yellow,
	BOOK_TYPE.Blue : book_blue,
}

const PUSH_TIME: float = .35

var tween: Tween

var can_be_pushed: int = 0

func _ready() -> void:
	object_interact_action.interacted.connect(_on_interacted)
	
	book_red.visible = false
	book_type_to_mesh[type].visible = true

func _on_interacted(player: PlayerBody) -> void:
	if can_be_pushed > 0: return
	if bookshelf.books_pushed.has(self): return
	
	bookshelf.add_book(self)
	push()

func push() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:z", pushed_pos_z, PUSH_TIME)


func unpush() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:z", default_pos_z, PUSH_TIME)
