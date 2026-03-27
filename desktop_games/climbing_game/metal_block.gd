extends CharacterBody2D
class_name MetalBlock

const GRAVITY: float = 300.0
const MAGNET_GRAVITY: float = -24.0

func _physics_process(delta: float) -> void:
	if DesktopManager.is_magnet_on:
		velocity.y = MAGNET_GRAVITY
	else:
		velocity.y += GRAVITY  * delta
	
	move_and_slide()

# FIXME: when it's falling and it falls on the player the player is stuck
# I guess it's similar to when the player is on top of it and there's a ceiling
