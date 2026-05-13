extends Node

func _ready() -> void:
	load_menu()

func quit():
	get_tree().quit()

func load_menu():
	for child in get_children():
		child.queue_free()

	var menu = preload("res://main_menu.tscn").instantiate()
	add_child(menu)
	
	var actions_container = get_node("MainMenu/CenterContainer/VBoxContainer/Actions")
	actions_container.get_node("NewGame").connect("pressed", new_game.bind())
	actions_container.get_node("Quit").connect("pressed", quit.bind())

func new_game():
	for child in get_children():
		child.queue_free()

	var game = preload("res://game.tscn").instantiate()
	add_child(game)
