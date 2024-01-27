@tool
extends Node2D

@export_range(50,250) var difficulty : float = 250:
	set(value):
		difficulty = value
		%"Right Peg".position.x = difficulty
		%"Left Peg".position.x = -difficulty
