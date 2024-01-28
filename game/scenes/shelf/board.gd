extends RigidBody2D

var is_active = true
var jumping_frames = 0

func _integrate_forces(_state):
	var cat = get_tree().get_first_node_in_group("cat")
	if not cat: return
	
	if cat.linear_velocity.y < -10:
		jumping_frames += 1
	else:
		jumping_frames = 0
	is_active = jumping_frames <= 5 or abs(rotation) > 0.01
	
	set_collision_layer_value(3, is_active)
	set_collision_mask_value(3, is_active)

func _process(_delta):
	$CollisionShape2D.modulate = Color.WHITE if is_active else Color.BLACK
