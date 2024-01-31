extends RigidBody2D


@export_category("Jumping")
@export var auto_jump = true
@export var jump_force = 6500
@export_range(0.1, 2.0) var auto_jump_horizontal_mod = 0.75
@export var jump_flick_threshold = 50
@export var jump_body_impulse_strength = 5000

@export_category("Slowdowns")
@export var just_landed_slowdown = 0.5
@export var air_slowdown = 0.5


@export_category("Horizontal Movement")
@export var horizontal_deadzone = 30
@export var horizontal_max_distance = 200
@export var horizontal_forward_force = 9000

@export_category("debug")
@export var debugging = false


var last_laser_pointer_position = Vector2.ZERO
var laser_pointer
var highest_ground_position = Vector2.ZERO

func end_game():
	set_deferred("freeze", true)

func get_lowest_point():
	return %LowestPoint.global_position

func is_on_ground():
	return not %GroundCheck.get_overlapping_bodies().is_empty()

func is_laser_close():
	return not %LaserCheck.get_overlapping_areas().is_empty()

func get_height():
	return %CollisionShape2D.shape.get_rect().size.y

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
	if !debugging:
		return
	var laser_dir = position.direction_to(last_laser_pointer_position)
	draw_line(Vector2.ZERO, laser_dir * 100, Color.RED, 3)
	
	# Slowdown indicators
	draw_line(Vector2.ZERO, Vector2.DOWN * 100 * distance_slowdown, Color.AQUA, 20)
	draw_line(Vector2.ZERO + Vector2.RIGHT * 30, Vector2.DOWN * 100 * fly_slowdown + Vector2.RIGHT * 30, Color.AQUA, 20)
	draw_line(Vector2.ZERO + Vector2.RIGHT * 60, Vector2.DOWN * 100 * horizontal_slowdown + Vector2.RIGHT * 60, Color.AQUA, 20)

func _on_laser_pointer_position_changed(pos):
	last_laser_pointer_position = pos
	if debugging:
		queue_redraw()

func is_opposite_horizontal_direction(a: Vector2, b: Vector2):
	return a.x * b.x < 0  

# These variables are made members for debug drawing
var fly_slowdown = 1.0
var horizontal_slowdown = 1.0
var distance_slowdown = 1.0
func _integrate_forces(state):
	var relative_laser_pos = last_laser_pointer_position - position
	var laser_dir = relative_laser_pos.normalized()
	
	if is_on_ground() and is_jump_cooldown_complete():
		var should_jump = false
		var jump_vector
		
		# Autojump fells more cat-like and works better with mouse
		if auto_jump and relative_laser_pos.length() > 300 and laser_dir.y < -0.8:
			##print("here", impulse_cooldown)
			should_jump = true
			jump_vector = laser_dir * jump_force * Vector2(auto_jump_horizontal_mod, 1)
		# Without Autojump we require a flick (maybe better for trackpad)
		if !auto_jump and laser_pointer.velocity > jump_flick_threshold:
			should_jump = true
			jump_vector = laser_dir * jump_force
		
		if should_jump:
			$JumpSound.play()
			state.apply_central_impulse(jump_vector)
			start_impulse_cooldown()
			for body in %GroundCheck.get_overlapping_bodies():
				if body is RigidBody2D:
					var impulse_pos = body.to_local(%GroundCheck.global_position)
					#print(impulse_pos)
					body.apply_impulse(Vector2.DOWN * jump_body_impulse_strength, impulse_pos)
			return
	
	if abs(relative_laser_pos.x) > horizontal_deadzone:
		fly_slowdown = 1.0 if is_on_ground() else air_slowdown
		horizontal_slowdown = 1.0 if is_jump_cooldown_complete() or is_opposite_horizontal_direction(laser_dir, linear_velocity) else just_landed_slowdown
		distance_slowdown = clampf(abs(relative_laser_pos.x), 0, horizontal_max_distance) / horizontal_max_distance
		if debugging:
			queue_redraw()
		var force = Vector2.ZERO
		force.x = laser_dir.x * distance_slowdown * horizontal_forward_force * horizontal_slowdown * fly_slowdown
		state.apply_central_force(force)
	elif is_on_ground():
		linear_velocity *= 0.9


var was_on_ground = true
func _physics_process(_delta):
	if is_on_ground() and not was_on_ground:
		$JumpSound.play()
		start_jump_cooldown()
	was_on_ground = is_on_ground()
	highest_ground_position = highest_ground_position if highest_ground_position.y < position.y else position

#var x = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
func _process(_delta):
	if linear_velocity.x < -50:
		%Icon.flip_h = true
	elif linear_velocity.x > 50:
		%Icon.flip_h = false
	if is_on_ground():
		if abs(linear_velocity.x) > 10:
			%Icon.animation = "run"
		else:
			if is_laser_close():
				%Icon.animation = "stand and look"
			else:
				%Icon.animation = "idle"
	else:
		%Icon.animation = "jump"
	if not %Icon.is_playing() and not %Icon.animation == "stand and look":
		%Icon.play()
	#queue_redraw()
	gravity_scale = 0.0 if is_on_ground() else 1.0
	#x.pop_front()
	#x.append(laser_pointer.velocity)
	#print(x.max())

func _ready():
	Level.respawn()
	
	laser_pointer = get_tree().get_first_node_in_group("laserpointer")
	laser_pointer.position_changed.connect(_on_laser_pointer_position_changed)
	last_laser_pointer_position = laser_pointer.position
	
	var end_window = get_tree().get_first_node_in_group("window")
	if end_window:
		end_window.game_finished.connect(end_game)
	
