@tool
extends Node2D

func _notification(what):
	if what == NOTIFICATION_PARENTED:
		if get_parent() is Sprite2D:
			$Sprite2D.texture = get_parent().texture
			position = Vector2.ZERO

func _get_configuration_warnings():
	if not get_parent() is Sprite2D:
		return ["Parent is not a Sprite"]
	return []
