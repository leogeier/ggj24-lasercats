extends Node2D

func _enter_tree():
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, 5, Color.BLACK)
