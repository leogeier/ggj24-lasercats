extends Node2D

var p
var last_velocity = Vector2.ZERO

func _ready():
	p = get_parent()
	if not p is RigidBody2D:
		p = null
		return
	
	await get_tree().process_frame
	p.contact_monitor = true
	p.max_contacts_reported = max(p.max_contacts_reported, 1)
	p.body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	last_velocity = p.linear_velocity

func node_has_sound(node):
	return node.get_children().any(func(n): return n.is_in_group("sound"))

func get_last_velocity(node):
	for c in node.get_children():
		if c.is_in_group("sound"):
			return c.last_velocity

func _on_body_entered(node):
	if last_velocity.length() > 1000 and (not node_has_sound(node) or get_last_velocity(node) < last_velocity):
		$AudioStreamPlayer.play()
