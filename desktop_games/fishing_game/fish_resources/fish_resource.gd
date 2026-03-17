extends Resource
class_name FishResource

@export var sprite: Texture2D
@export var fish_size: SIZE

@export var default_money_value: float

@export var move_pattern: MOVE
@export var move_range: float = 1.0
@export var move_speed: float = 16.0

enum SIZE {
	Small,
	Medium,
	Big,
}

enum MOVE {
	Static,
	Sideways,
	SineSideways,
	Circle,
	RandomInRadius,
}
