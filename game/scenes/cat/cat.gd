extends RigidBody2D

@export var horizontal_forward_force = 10000
@export var jump_force = 3000

var last_laser_pointer_position = Vector2.ZERO

#func _input(event):
	#if event is InputEventMouseMotion:
		#last_laser_pointer_position = event.position

func is_on_ground():
	return not %GroundCheck.get_overlapping_bodies().is_empty()

func is_laser_close():
	return not %LaserCheck.get_overlapping_areas().is_empty()

var impulse_cooldown = false
func is_jump_cooldown_complete():
	return $JumpTimer.is_stopped() and not impulse_cooldown

func start_jump_cooldown():
	$JumpTimer.start()

func start_impulse_cooldown():
	impulse_cooldown = true
	await get_tree().create_timer(.1).timeout
	impulse_cooldown = false

func _draw():
	var dir = position.direction_to(last_laser_pointer_position)
	draw_line(Vector2.ZERO, dir * 100, Color.RED, 3)

func _on_laser_pointer_position_changed(pos):
	last_laser_pointer_position = pos

func _integrate_forces(state):
	var laser_dir = position.direction_to(last_laser_pointer_position)
	var force = Vector2.ZERO
	force.x = laser_dir.x * horizontal_forward_force if is_on_ground() else 0
	state.apply_central_force(force)
	if is_on_ground() and not is_laser_close() and is_jump_cooldown_complete() and laser_dir.y < -0.8:
		#print("here", impulse_cooldown)
		state.apply_central_impulse(Vector2(0, -jump_force))
		start_impulse_cooldown()

var was_on_ground = true
func _physics_process(_delta):
	if is_on_ground() and not was_on_ground:
		start_jump_cooldown()
	was_on_ground = is_on_ground()

func _process(_delta):
	queue_redraw()

func _ready():
	get_tree().get_first_node_in_group("laserpointer").position_changed.connect(_on_laser_pointer_position_changed)
