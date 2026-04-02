extends AnimatedSprite2D
class_name RPGAnimationController


@export var player: RPGPlayer
@export var state_machine: StateMachine

@onready var eyes: Sprite2D = %Eyes

var last_velocity_x: float


func _ready() -> void:
	state_machine.state_changed.connect(_on_state_changed)
	DesktopManager.rpg_started_flying.emit(_on_state_changed)

func _on_state_changed() -> void:
	if DesktopManager.rpg_flying:
		play("flying")
	else:
		match state_machine.current_state_name:
			"idle", "battle":
				play("idle")
			"walk":
				play("walk")

func _process(delta: float) -> void:
	match animation:
		"idle", "battle":
			eyes.position.x = -1 if flip_h else 1
			eyes.position.y = 0 if frame == 0 else 1
		"walk":
			eyes.position.x = -1 if flip_h else 1
			eyes.position.y = 0
		"flying":
			offset.y = -8.0
			eyes.position.x = 0
			eyes.position.y = -7
	
	if is_zero_approx(player.velocity.x): return
	
	flip_h = player.velocity.x < 0
