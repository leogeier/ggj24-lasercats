extends Control

func _ready():
	var camera = get_tree().get_first_node_in_group("camera")
	if !camera:
		return
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera, "zoom", Vector2.ONE / 2, 5)

func _on_try_again_pressed():
	get_tree().reload_current_scene()
	self.queue_free()
