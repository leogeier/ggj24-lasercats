extends Node2D

signal position_changed(pos)

var velocity = 0
var last_position = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		position = event.position
		position_changed.emit(get_laser_position())

var _laser_line = Vector2.ZERO
func _draw():
	draw_line(Vector2.ZERO, _laser_line, Color.RED, 2)

func get_laser_position():
	return position

func _physics_process(_delta):
	_laser_line = last_position - get_laser_position()
	queue_redraw()
	velocity = get_laser_position().distance_to(last_position)
	last_position = get_laser_position()
