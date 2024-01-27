extends Camera2D

var kitty

var start_position
var finished = false
# Called when the node enters the scene tree for the first time.
func _ready():
	kitty = get_tree().get_first_node_in_group("cat")
	var end_window = get_tree().get_first_node_in_group("window")
	end_window.game_finished.connect(end_game)
	start_position = position

func end_game():
	finished = true
	self.position = start_position

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
	new_position += self.get_half_extent().y / 3
	# negative is up, so use the "min" to ensure the camera never goes down!
	position.y = min(new_position, position.y)

func get_half_extent():
	return get_viewport_rect().size / 2.0


func check_for_fall():
	var kitty_height = kitty.get_height()
	# For y positive is down, so if the position is too large, we've fallen!
	if kitty.position.y > position.y + get_half_extent().y + kitty_height /2:
		game_over()

func game_over():
	print("GAME OVER!")
