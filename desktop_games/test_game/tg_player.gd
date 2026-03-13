extends CharacterBody2D

@export var input: TestGameInput

const SPEED: float = 128.0
const JUMP_POWER: float = 256.0

const GRAVITY: float = 16.0

func _physics_process(_delta: float) -> void:
	velocity.x = input.input_dir_x * SPEED
	
	if input.just_jumped and is_on_floor():
		velocity.y = -JUMP_POWER
	elif !is_on_floor():
		velocity.y += GRAVITY
	else:
		velocity.y = 0.0
	
	move_and_slide()
