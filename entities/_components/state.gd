extends Node
class_name State

@export var type: String = ""

var state_machine: StateMachine


func enter() -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
