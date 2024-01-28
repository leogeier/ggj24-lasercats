extends PinJoint2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(self.node_a).body_entered.connect(_on_impact)
	get_node(self.node_b).body_entered.connect(_on_impact)

func _on_impact(body: Node):
	if body.is_in_group("cat"):
		get_node(self.node_a).set_deferred("lock_rotation", false)
		get_node(self.node_b).set_deferred("lock_rotation", false)
		self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
