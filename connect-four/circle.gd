extends Node2D

@export var color: Color

func _draw():
	draw_circle(Vector2.ZERO, 0.5, color)
