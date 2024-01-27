@tool
extends Node2D

@export_range(25,500) var peg_distance : float = 200:
	set(value):
		peg_distance = value
		%"Right Peg".position.x = peg_distance
		%"Left Peg".position.x = -peg_distance

@export_range(0.1, 5.0) var board_width: float = 1.0:
	set(value):
		board_width = value
		$board/Modularshelf.scale.x = board_width * 0.266
		$board/CollisionShape2D.scale.x = board_width

@export_range(-200, 200) var side_offset: float = 0:
	set(value):
		side_offset = value
		$board/Modularshelf.position.x = side_offset
		$board/CollisionShape2D.position.x = side_offset
