extends Control

const GAME_GRID = preload("res://AI/GameGrid.gd")

var difficulty: String


func start_game() -> void:
	for child in get_parent().get_children():
		child.queue_free()

	var select_color = preload("res://select_color.tscn").instantiate()
	select_color.difficulty = difficulty
	get_parent().add_child(select_color)


func _on_easy_button_pressed() -> void:
	difficulty = GAME_GRID.DIFFICULTY_EASY
	start_game()


func _on_medium_button_pressed() -> void:
	difficulty = GAME_GRID.DIFFICULTY_MEDIUM
	start_game()


func _on_hard_button_pressed() -> void:
	difficulty = GAME_GRID.DIFFICULTY_HARD
	start_game()
