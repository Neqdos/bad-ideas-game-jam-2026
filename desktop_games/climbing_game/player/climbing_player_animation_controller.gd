extends AnimatedSprite2D
class_name AnimationController


@export var player: ClimbingPlayer
@export var state_machine: StateMachine

@onready var eyes: Sprite2D = %Eyes

var last_velocity_x: float

var hook_dir: Vector2

var tween: Tween

func _ready() -> void:
	state_machine.state_changed.connect(_on_state_changed)

func _on_state_changed() -> void:
	match state_machine.current_state_name:
		"idle":
			play("idle")
		"walk":
			play("walk")
		"jump":
			play("jump")
		"falling":
			play("jump")
		"hookshot":
			match hook_dir:
				Vector2.RIGHT:
					play("hook_side")
					flip_h = false
				Vector2.LEFT:
					play("hook_side")
					flip_h = true
				Vector2.UP:
					play('hook_up')
				Vector2.DOWN:
					play("hook_down")

func _process(delta: float) -> void:
	match animation:
		"idle":
			eyes.position.x = 0
			eyes.position.y = -10 if frame == 0 else -11
		"walk", "jump":
			eyes.position.y = -11
			eyes.position.x = -1 if flip_h else 1
		"hook_up":
			eyes.position.y = -11
			eyes.position.x = 0
		"hook_down":
			eyes.position.y = -9
			eyes.position.x = 0
		"hook_side":
			eyes.position.y = -10
			eyes.position.x = 0
	
	if is_zero_approx(player.velocity.x): return
	
	flip_h = player.velocity.x < 0


func squish_x() -> void:
	if tween: tween.kill()
	
	scale = Vector2(1.4, .75)
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, .25)

func squish_y() -> void:
	if tween: tween.kill()
	
	scale = Vector2(.4, 1.4)
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, .3)
