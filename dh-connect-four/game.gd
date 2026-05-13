extends Node2D

@onready var button_container = get_node("CenterContainer/CenterContainer/ButtonContainer")
@onready var column_buttons = button_container.get_children()

@onready var result_label = $Control/HBoxContainer/Label
@onready var play_button = $Control/HBoxContainer/AIPlay
@onready var menu_button = $Control/HBoxContainer/MenuButton

signal hide_preview

const MAIN_MENU = preload("res://main_menu.tscn")

const MINIMAX_PODA = preload("res://minimax_poda.gd")
const MINIMAX = preload("res://minimax.gd")
var mmp: MinimaxPoda = MinimaxPoda.new()
var mm: Minimax = Minimax.new()

const GAME_GRID = preload("res://game_grid.gd")
const CIRCLE = preload("res://circle.tscn")
const CIRCLE_PADDING = 20
const CIRCLE_WIDTH = 100 + CIRCLE_PADDING*2

var game: GameGrid = GameGrid.new()

var preview_circles: Array = []

func _input(event: InputEvent) -> void:
	# Setup pause
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_config_pause_menu_buttons()
	_config_result_menu_buttons()
	_setup_column_buttons()
	
	menu_button.connect("pressed", toggle_pause_menu.bind())

func _setup_column_buttons():
	var column_index: int = 0
	for button in column_buttons:
		button.disabled = false
		button.connect("mouse_entered", play_preview_action.bind(column_index, button))
		button.connect("pressed", play_action.bind(column_index, button))
		column_index += 1


# TODO: Move this to game_grid script
func _get_current_row(column_index) -> int:
	for row in range(5, -1, -1):
		# Check if column has value
		if game.grid[row][column_index] == GAME_GRID.EMPTY:
			return row
	
	# TODO: depois eu vejo
	return -1

func _hide_preview():
	for circle in preview_circles:
		if circle:
			circle.queue_free()
	preview_circles = []
		

func play_preview_action(column_index, button) -> void:
	hide_preview.emit()
	
	var current_row = _get_current_row(column_index)

	if current_row < 0:
		return

	# Load preview circle
	var circle = CIRCLE.instantiate()
	circle.position.x += CIRCLE_PADDING
	#circle.position.y -= CIRCLE_WIDTH/1.3 # preview in top
	circle.position.y = button_container.size.y + CIRCLE_WIDTH/2 - CIRCLE_WIDTH * (len(game.grid) - current_row) # preview in future spot
	#circle.get_node("Label").text = game.current_player()
	circle.color = Color(game.current_player())
	circle.color.a = 0.7
	var column = button_container.get_children()[column_index]
	circle.add_user_signal("hide_preview")
	preview_circles.append(circle)
	
	column.add_child(circle)
	

func play_action(column_index, button) -> void:
	hide_preview.emit()
	var currentRow = _get_current_row(column_index)
	_make_play(Vector2(currentRow, column_index))
	
	
func _make_play(movement: Vector2) -> void:
	if game.jogada(movement):
		var evaluation: float = game.evaluate()

		if abs(evaluation) >= 100000:
			var result = ""
			if game.current_player() == GameGrid.RED:
				result = "Red won!"
			else:
				result = "Yellow won!"

			game_over(result)
			
		elif game.empate():
			game_over("Draw!")

		# Interface
		var circle = CIRCLE.instantiate()
		circle.position.x += CIRCLE_PADDING
		circle.position.y = button_container.size.y + CIRCLE_WIDTH/2 - CIRCLE_WIDTH * (len(game.grid) - movement.x)
		#circle.get_node("Label").text = game.current_player()
		circle.color = game.current_player()
		var column = button_container.get_children()[movement.y]
		column.add_child(circle)
		
		game.switch_player()


func game_over(result) -> void:
	disable_buttons()
	$ResultContainer.visible = true
	$ResultContainer/VBoxContainer/ResultLabel.text = result


func _on_ai_play_button_pressed() -> void:
	disable_buttons()
	var player: String = game.current_player()
	var current_play: Play = mm.melhor_jogada(game.duplicate(true), player, 1)
	#var current_play: Play = mmp.melhor_jogada(game.duplicate(true), player)

	print("AI movement: ", current_play.movimento)
	print("AI evaluation: ", current_play.avaliacao)

	_make_play(current_play.movimento)

	enable_buttons()
		
func disable_buttons() -> void:
	for button in column_buttons:
		button.disabled = true

func enable_buttons() -> void:
	for button in column_buttons:
		button.disabled = false

func reset_game() -> void:
	# Empty game grid
	game = GameGrid.new()
	for button in column_buttons:
		button.text = game.EMPTY

	# Empty interface grid
	for button in column_buttons:
		for child in button.get_children():
			child.queue_free()
	
	# Enable buttons and clean label
	enable_buttons()
	
	# Close pause and result menu in case it's visible
	$PauseContainer.visible = false
	$ResultContainer.visible = false

func _config_result_menu_buttons():
	$ResultContainer/VBoxContainer/HBoxContainer/RestartButton.connect("pressed", reset_game.bind())
	$ResultContainer/VBoxContainer/HBoxContainer/QuitButton.connect("pressed", quit_to_main_menu.bind())

func _config_pause_menu_buttons():
	$PauseContainer/VBoxContainer/ContinueButton.connect("pressed", toggle_pause_menu.bind())
	$PauseContainer/VBoxContainer/RestartButton.connect("pressed", reset_game.bind())
	$PauseContainer/VBoxContainer/QuitButton.connect("pressed", quit_to_main_menu.bind())

func quit_to_main_menu():
	get_parent().load_menu()

func toggle_pause_menu():
	$PauseContainer.visible = !$PauseContainer.visible
