extends Node2D

var kitty
# Called when the node enters the scene tree for the first time.
func _ready():
	kitty = get_tree().get_first_node_in_group("cat")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !kitty:
		return
	var relative_pos = kitty.global_position - self.global_position
	if relative_pos.x > 30:
		self.scale.x = -1
	if relative_pos.x < -30:
		self.scale.x = 1
