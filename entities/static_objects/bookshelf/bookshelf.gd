extends AnimatableBody3D
class_name Bookshelf

@export var move_pos_marker: Marker3D
@export var all_books: Array[Book]

@onready var moving_sound: AudioStreamPlayer3D = %MovingSound

const CORRECT_BOOKS_PUSH_ORDER: Array[Book.BOOK_TYPE] = [
	Book.BOOK_TYPE.Red,
	Book.BOOK_TYPE.Green,
	Book.BOOK_TYPE.Purple,
	Book.BOOK_TYPE.Yellow,
	Book.BOOK_TYPE.Blue,
]

const MAX_BOOKS: int = 5
const TWEEN_TIME: float = 3.0

var books_pushed: Array[Book]
var is_unlocked: bool = false

var tween: Tween

func add_book(book: Book) -> void:
	books_pushed.append(book)
	book.can_be_pushed += 1
	
	if books_pushed.size() == MAX_BOOKS:
		await get_tree().create_timer(.5).timeout
		
		var types_in_order: Array[Book.BOOK_TYPE]
		
		for b: Book in books_pushed:
			types_in_order.append(b.type)
			
		
		if !is_unlocked and types_in_order == CORRECT_BOOKS_PUSH_ORDER:
			_unlock()
		else:
			for b: Book in books_pushed:
				b.unpush()
			
			books_pushed.clear()
			
			await get_tree().create_timer(Book.PUSH_TIME).timeout
			
			for b: Book in all_books:
				b.can_be_pushed -= 1

func _unlock() -> void:
	is_unlocked = true
	
	moving_sound.play()
	
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(self, "global_position", move_pos_marker.global_position, TWEEN_TIME)
	
	for book: Book in all_books:
		var pos: Vector3 = book.position#move_pos_marker.global_position - (move_pos_marker.global_position - book.global_position)
		tween.tween_property(book, "position", pos, TWEEN_TIME)
	
	await tween.finished
	
	for book: Book in all_books:
		book.can_be_pushed -= 1
