extends Node2D

var checkpoint = null


func respawn():
	if checkpoint == null:
		return
	
	var checkpoint_node = get_node(checkpoint)
	var cat = get_tree().get_first_node_in_group("cat")
	
	if cat and checkpoint_node:
		relative_respawn(checkpoint_node, cat, "laserpointer")
		#relative_respawn(checkpoint_node, cat, "camera")
		cat.global_position = checkpoint_node.global_position

func relative_respawn(checkpoint_node: Node2D, cat: Node2D, group: String):
	var the_node = get_tree().get_first_node_in_group("laserpointer")
	if the_node:
		var relative = the_node.global_position - cat.global_position
		the_node.global_position = checkpoint_node.global_position + relative
	
