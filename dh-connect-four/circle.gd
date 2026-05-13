extends Node2D

@export var color: Color

func _draw():
	# Draws a white circle at the node's center with a 50px radius
	draw_circle(Vector2.ZERO, 0.5, color)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
