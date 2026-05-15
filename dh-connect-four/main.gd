extends Node
@export var bgm: AudioStream

func _ready() -> void:
	AudioManager.play_background_music(bgm)
	load_menu()

func quit():
	get_tree().quit()

func load_menu():
	for child in get_children():
		child.queue_free()

	var menu = preload("res://main_menu.tscn").instantiate()
	add_child(menu)
	
	var actions_container = get_node("MainMenu/CenterContainer/VBoxContainer/Actions")
	actions_container.get_node("PvCGame").connect("pressed", new_pvc_game.bind())
	actions_container.get_node("PvPGame").connect("pressed", new_pvp_game.bind())
	actions_container.get_node("AIGame").connect("pressed", new_ai_game.bind())
	actions_container.get_node("Quit").connect("pressed", quit.bind())

func _new_game(scene) -> void:
	for child in get_children():
		child.queue_free()

	add_child(scene)

func new_pvc_game():
	_new_game(preload("res://select_difficulty.tscn").instantiate())

func new_pvp_game():
	var game = preload("res://game.tscn").instantiate()
	game.game_type = "pvp"
	_new_game(game)

func new_ai_game():
	var game = preload("res://game.tscn").instantiate()
	game.game_type = "ai_demo"
	_new_game(game)
