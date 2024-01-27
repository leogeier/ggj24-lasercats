extends Node2D

signal game_finished()

var finished = false
var end_scene = preload("res://menus/end card.tscn")


func _on_window_entered(area):
	if finished:
		return
	finished = true
	
	var end_screen = end_scene.instantiate()
	get_tree().get_first_node_in_group("camera").add_child(end_screen)

	game_finished.emit()
	
