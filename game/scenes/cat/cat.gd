extends RigidBody2D

var last_laser_pointer_position = Vector2.ZERO

#func _input(event):
	#if event is InputEventMouseMotion:
		#last_laser_pointer_position = event.position

func is_on_ground():
	return not %GroundCheck.get_overlapping_bodies().is_empty()

func _on_laser_pointer_position_changed(pos):
	last_laser_pointer_position = pos

func _physics_process(delta):
	var laser_dir = position.direction_to(last_laser_pointer_position)
	var force = Vector2()
	force.x = laser_dir.x * 600000 if is_on_ground() else 0
	force.y = -4000000 if is_on_ground() and laser_dir.y < -0.8 else 0
	apply_central_force(delta * force)

func _ready():
	get_tree().get_first_node_in_group("laserpointer").position_changed.connect(_on_laser_pointer_position_changed)
