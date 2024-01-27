extends RigidBody2D

@export var horizontal_forward_force = 10000
@export var jump_force = 3000
@export var jump_flick_threshold = 100

var last_laser_pointer_position = Vector2.ZERO
var laser_pointer

#func _input(event):
	#if event is InputEventMouseMotion:
		#last_laser_pointer_position = event.position

func is_on_ground():
	return not %GroundCheck.get_overlapping_bodies().is_empty()

func is_laser_close():
	return not %LaserCheck.get_overlapping_areas().is_empty()

func get_height():
	return %Icon.get_rect().size.y

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
	
	if is_on_ground() and is_jump_cooldown_complete():
		var should_jump = false
		var jump_vector
		
		if not is_laser_close() and laser_dir.y < -0.8:
			#print("here", impulse_cooldown)
			should_jump = true
			jump_vector = laser_dir * jump_force * Vector2(0.5, 1)
		elif is_laser_close() and laser_pointer.velocity > jump_flick_threshold:
			should_jump = true
			jump_vector = laser_dir * jump_force
		
		if should_jump:
			state.apply_central_impulse(jump_vector)
			start_impulse_cooldown()

var was_on_ground = true
func _physics_process(_delta):
	if is_on_ground() and not was_on_ground:
		start_jump_cooldown()
	was_on_ground = is_on_ground()

#var x = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
func _process(_delta):
	queue_redraw()
	#x.pop_front()
	#x.append(laser_pointer.velocity)
	#print(x.max())

func _ready():
	laser_pointer = get_tree().get_first_node_in_group("laserpointer")
	laser_pointer.position_changed.connect(_on_laser_pointer_position_changed)
