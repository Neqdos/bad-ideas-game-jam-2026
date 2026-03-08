extends RigidBody3D
class_name RigidObject

signal grabbed()
signal held()
signal hold_owner_changed()

@export var obj_resource: ObjectResource

var hold_owner: PlayerBody = null:
	set(val):
		hold_owner = val
		hold_owner_changed.emit()
		if is_instance_valid(val): held.emit()

var grab_owner: PlayerBody = null:
	set(val):
		grab_owner = val
		if is_instance_valid(val): grabbed.emit()
