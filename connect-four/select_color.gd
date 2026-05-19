extends Control

@onready var player1_red = $VBoxContainer/MarginContainer/GridContainer/Player1Red
@onready var player1_yellow = $VBoxContainer/MarginContainer/GridContainer/Player1Yellow

var mouse_texture = preload("res://art/mouse.png")
var player1_is_red: bool = true
var difficulty: String

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		select_yellow()
	
	if event.is_action_pressed("ui_left"):
		select_red()

func select_red() -> void:
	player1_is_red = true
	player1_red.texture = mouse_texture
	player1_yellow.texture = null

func select_yellow() -> void:
	player1_is_red = false
	player1_red.texture = null
	player1_yellow.texture = mouse_texture


func start_game() -> void:
	for child in get_parent().get_children():
		child.queue_free()

	print("difficulty: ", difficulty)

	var game = preload("res://game.tscn").instantiate()
	game.game_type = "pvc"
	game.player1_is_red = player1_is_red
	game.difficulty = difficulty
	get_parent().add_child(game)
