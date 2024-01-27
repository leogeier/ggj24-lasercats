extends Camera2D

var kitty
# Called when the node enters the scene tree for the first time.
func _ready():
	kitty = get_tree().get_first_node_in_group("cat")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_camera()
	check_for_fall()

func move_camera():
	var new_position = kitty.position.y
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
