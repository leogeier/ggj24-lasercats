extends Camera2D

signal kitty_fell()

var kitty
var start_position
var finished = false
# Called when the node enters the scene tree for the first time.
func _ready():
	kitty = get_tree().get_first_node_in_group("cat")
	var end_window = get_tree().get_first_node_in_group("window")
	if end_window:
		end_window.game_finished.connect(end_game)
	start_position = position

func end_game():
	finished = true
	await get_tree().create_timer(2).timeout
	position_smoothing_enabled = false
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", start_position, 4)
	#self.position = start_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if finished:
		return
	
	move_camera()
	check_for_fall()
	if Input.is_action_pressed("ui_down"):
		position.y += delta * position_smoothing_speed * 200
	if Input.is_action_pressed("ui_up"):
		position.y -= delta * position_smoothing_speed * 200

func move_camera():
	var new_position = kitty.position.y
	new_position -= self.get_half_extent().y * 0.1
	# negative is up, so use the "min" to ensure the camera never goes down!
	position.y = min(new_position, position.y)

func get_half_extent():
	return get_viewport_rect().size / 2.0


func check_for_fall():
	var kitty_height = kitty.get_height()
	# For y positive is down, so if the position is too large, we've fallen!
	if kitty.position.y > position.y + get_half_extent().y + kitty_height:
		game_over()

var game_over_scene = preload("res://menus/game over.tscn")
func game_over():
	kitty.queue_free()
	add_child(game_over_scene.instantiate())
	kitty_fell.emit()
	end_game()
