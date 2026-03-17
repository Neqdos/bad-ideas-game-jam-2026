extends Resource
class_name FileResource

@export var name: String
@export var icon: Texture2D
@export var window_size: Vector2 = Vector2(400.0, 300.0)

@export var title_bar_color: TITLE_BAR_COLOR = TITLE_BAR_COLOR.Black

enum TITLE_BAR_COLOR {
	## Used mainly for text and image files.
	Black,
	White,
	## Used mainly for games.
	Blue,
	## Used mainly for pop ups.
	Red,
	## Used mainly for apps.
	Yellow,
	Green,
}
