@tool
extends RigidBody2D

var is_connected = true

func _enter_tree():
	queue_redraw()

func _physics_process(_delta):
	if not is_connected: return
	
	if abs(rotation) > 0.6:
		is_connected = false
		queue_redraw()
		$"../PinJoint2D".queue_free()
		$CollisionShape2D.disabled = true
		$BigCollider.disabled = false

func _draw():
	if not is_connected: return
	
	var start = to_local($"../PinJoint2D".global_position)
	draw_line(start, $MarkerLeft.position, Color.BLACK, 3, true)
	draw_line(start, $MarkerRight.position, Color.BLACK, 3, true)
	
