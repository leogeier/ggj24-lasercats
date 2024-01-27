extends Node2D

signal position_changed(pos)

var velocity = 0
var last_position = Vector2.ZERO
var camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = get_tree().get_first_node_in_group("camera")

const SENSITIVITY = 0.5
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		position += event.relative * SENSITIVITY
		position_changed.emit(get_laser_position())
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

var _laser_line = Vector2.ZERO
func _draw():
	draw_circle(Vector2.ZERO, 10, Color.RED)
	var points = [Vector2.ZERO, _laser_line]
	var red_transparent = Color.RED
	red_transparent.a = 0
	var colors = [Color.RED, red_transparent]
	draw_polyline_colors(points, colors, 5, true)

func _process(delta):
	#var camera_rect = camera.get_canvas_transform().affine_inverse().basiss_xform(camera.get_viewport_rect().size)
	var camera_rect = camera.get_viewport_rect()
	print(camera_rect)

func get_laser_position():
	return position

func _physics_process(_delta):
	_laser_line = last_position - get_laser_position()
	queue_redraw()
	velocity = get_laser_position().distance_to(last_position)
	last_position = get_laser_position()
