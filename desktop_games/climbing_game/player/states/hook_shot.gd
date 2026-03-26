extends State

@export var player: ClimbingPlayer
@export var animation_controller: AnimationController

@onready var hook_raycast: RayCast2D = %HookRaycast
@onready var hook_sprite: Sprite2D = %HookSprite
@onready var hook_line: Line2D = %HookLine
@onready var wind_particles: GPUParticles2D = %WindParticles


const OFFSET: float = 5.0
const SPEED: float = 256.0

const TIME_TO_JUMP_AFTER: float = .5

var tween: Tween

func enter() -> void:
	player.can_move += 1
	player.velocity = Vector2.ZERO
	
	player.hook_uses += 1
	
	hook_raycast.target_position.x = DesktopManager.max_hook_travel_distance * 8.0
	
	if Vector2(player.input.input_x, player.input.input_y).is_zero_approx():
		hook_raycast.rotation = -int(animation_controller.flip_h) * PI
		wind_particles.rotation = 0.0
	else:
		if absf(player.input.input_x) > absf(player.input.input_y):
			hook_raycast.rotation = minf(0.0, player.input.input_x) * PI
			wind_particles.rotation = 0.0
		else:
			hook_raycast.rotation = player.input.input_y * PI / 2.0
			wind_particles.rotation = PI / 2.0
	
	animation_controller.hook_dir = Vector2.from_angle(hook_raycast.rotation).round()
	hook_sprite.rotation = hook_raycast.rotation
	hook_sprite.global_position = player.global_position
	hook_sprite.visible = true
	hook_line.visible = true
	
	hook_line.set_point_position(1, hook_sprite.position)
	
	hook_raycast.force_raycast_update()
	
	if hook_raycast.is_colliding():
		var collider = hook_raycast.get_collider()
		
		shoot_hook_sprite(hook_raycast.get_collision_point())
		
		if collider is TileMapLayer:
			var collider_rid: RID = hook_raycast.get_collider_rid()
			var coords: Vector2i = collider.get_coords_for_body_rid(collider_rid)
			var tile_data: TileData = collider.get_cell_tile_data(coords)
			
			var normal: Vector2 = hook_raycast.get_collision_normal()
			
			await tween.finished
			
			if tile_data and tile_data.get_custom_data("can_hook"):
				wind_particles.emitting = true
				hook(normal * OFFSET)
				await tween.finished
				if player.input.jump_pressed:
					state_machine.change_state("jump")
					return
				else:
					player.koyote_timer.start()
		else:
			await tween.finished
	else:
		shoot_hook_sprite(hook_raycast.global_position + Vector2.from_angle(hook_raycast.rotation) * hook_raycast.target_position.length())
		await tween.finished
	state_machine.change_state("falling")

func update(delta: float) -> void:
	hook_line.set_point_position(1, hook_sprite.position)

func shoot_hook_sprite(to: Vector2) -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(hook_sprite, "global_position", to, player.global_position.distance_to(to) / SPEED)

func hook(offset: Vector2) -> void:
	var time: float = player.global_position.distance_to(hook_sprite.global_position) / SPEED
	var pos: Vector2 = hook_sprite.global_position
	
	tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(player, "global_position", pos + offset, time)
	tween.tween_property(hook_sprite, "position", Vector2.ZERO - offset, time)

func exit() -> void:
	player.can_move -= 1
	hook_sprite.position = Vector2.ZERO
	wind_particles.emitting = false
	hook_sprite.visible = false
	hook_line.visible = false
