@tool
extends Node2D

@export_range(50,250) var difficulty : float = 250:
	set(value):
		difficulty = value
		%"Right Peg".position.x = difficulty
		%"Left Peg".position.x = -difficulty

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
