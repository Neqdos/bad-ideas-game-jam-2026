extends Node
class_name StateMachine

signal state_changed()

@export var initial_state: State

var current_state: State
var current_state_name: String:
	get():
		if is_instance_valid(current_state):
			return current_state.name.to_lower()
		else:
			return ""

var states: Dictionary[String, State] = {}

func _ready() -> void:
	for state in get_children():
		if state is State:
			state.state_machine = self
			states[state.name.to_lower()] = state
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(new_state_name: String) -> void:
	var new_state: State = states.get(new_state_name.to_lower())
	
	assert(new_state, "State not found " + new_state_name)
	
	var old_state: State
	
	if current_state:
		old_state = current_state
	
	new_state.enter()
	
	current_state = new_state
	state_changed.emit()
	
	old_state.exit()
