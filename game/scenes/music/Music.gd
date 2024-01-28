extends Node

@onready var current_track = $Stage1

var i = 1
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		change_to_track(get_children()[i].name)
		i = min(get_children().size() - 1, i + 1)

func change_to_track(track_name):
	if track_name == current_track.name: return
	
	var next_track = get_node(NodePath(track_name))
	
	var tween = get_tree().create_tween()
	tween.tween_method(func(v):
		next_track.volume_db = linear_to_db(v * 0.251189)
		current_track.volume_db = linear_to_db((1.0 - v) * 0.251189)
		, 0.0, 1.0, 5)
	
	await tween.finished
	print("lol")
	current_track = next_track
