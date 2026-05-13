extends Control

@onready var actions_container = get_node("CenterContainer/VBoxContainer/Actions")
@onready var actions = actions_container.get_children()

const GAME = preload("res://game.tscn")

func _ready() -> void:
	actions_container.get_node("NewGame").connect("pressed", new_game.bind())
	actions_container.get_node("Quit").connect("pressed", quit.bind())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	

func new_game():
	get_tree().change_scene_to_packed(GAME)

func quit():
	get_tree().quit()
