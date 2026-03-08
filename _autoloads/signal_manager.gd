extends Node

@warning_ignore_start("unused_signal")

signal camera_lock(is_locked: bool)
signal camera_position_at(transform: Transform3D)

signal player_input_lock(is_locked: bool)

signal add_node_to_interaction_ray_blacklist(node: Node, ray: InteractionRay)
signal remove_node_from_interaction_ray_blacklist(node: Node, ray: InteractionRay)

signal change_player_ui_visibility(visible: bool)

signal send_message(text: String)


func enter_screen(camera_transform: Transform3D, blacklisted_object: Node, player: PlayerBody, gui_panel: GUIPanel) -> void:
	camera_lock.emit(true)
	camera_position_at.emit(camera_transform)
	player_input_lock.emit(true)
	
	add_node_to_interaction_ray_blacklist.emit(blacklisted_object, player.player_interaction_ray)
	
	gui_panel.active = true
	gui_panel.player = player
	change_player_ui_visibility.emit(false)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func exit_screen(blacklisted_object: Node, player: PlayerBody, gui_panel: GUIPanel) -> void:
	camera_lock.emit(false)
	camera_position_at.emit(Transform3D())
	player_input_lock.emit(false)
	
	remove_node_from_interaction_ray_blacklist.emit(blacklisted_object, player.player_interaction_ray)
	
	gui_panel.active = false
	gui_panel.player = null
	change_player_ui_visibility.emit(true)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
