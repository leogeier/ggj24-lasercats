extends Node2D

signal position_changed(pos)

func _input(event):
	if event is InputEventMouseMotion:
		position = event.position
		position_changed.emit(get_laser_position())

func get_laser_position():
	return position
