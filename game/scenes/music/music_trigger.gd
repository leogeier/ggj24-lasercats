@tool
extends Node2D

@export_enum("Stage1", "Stage2", "Stage3", "Stage4")
var track_name = "Stage1"
@export var zoom_target = 1.0

@export var show_in_game = false

var has_triggered = false

func _process(_delta):
	if has_triggered: return
	
	var cat = get_tree().get_first_node_in_group(&"cat")
	if cat and cat.global_position.y < global_position.y:
		trigger()

func trigger():
	get_tree().call_group(&"music", &"change_to_track", track_name)
	
	var cam = get_tree().get_first_node_in_group("camera")
	if cam:
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(cam, "zoom", Vector2.ONE * zoom_target, 5)
	
	for child in get_children():
		if child.is_in_group("checkpoint"):
			Level.checkpoint = child.get_path()
			break
	
	has_triggered = true

func _enter_tree():
	if show_in_game or Engine.is_editor_hint():
		queue_redraw()

func _draw():
	if show_in_game or Engine.is_editor_hint():
		draw_line(Vector2.LEFT * 1000, Vector2.RIGHT * 1000, Color.MAGENTA, 10)
