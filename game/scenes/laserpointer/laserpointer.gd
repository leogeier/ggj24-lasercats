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
	draw_circle(Vector2.ZERO, 10, Color.RED)
	var points = [Vector2.ZERO, _laser_line]
	var red_transparent = Color.RED
	red_transparent.a = 0
	var colors = [Color.RED, red_transparent]
	draw_polyline_colors(points, colors, 5, true)

func get_laser_position():
	return position

func _physics_process(_delta):
	_laser_line = last_position - get_laser_position()
	queue_redraw()
	velocity = get_laser_position().distance_to(last_position)
	last_position = get_laser_position()
