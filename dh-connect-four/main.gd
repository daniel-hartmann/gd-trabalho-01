extends Node2D

@onready var buttonContainer = $ButtonContainer
@onready var columnButtons = buttonContainer.get_children()


const GAME_GRID = preload("res://game_grid.gd")
const CIRCLE = preload("res://circle.tscn")
const CIRCLE_WIDTH = 130

var game: GameGrid = GameGrid.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var buttons = buttonContainer.get_children()

	var x = buttons[-7]
	
	x.duplicate()
	
	var column_index: int = 0
	for button in columnButtons:
		button.connect("pressed", _on_button_click.bind(column_index, button))
		column_index += 1


# TODO: Move this to game_grid script
func _get_current_row(columnIndex) -> int:
	for row in range(5, -1, -1):
		# Check if column has value
		if game.grid[row][columnIndex] == GAME_GRID.EMPTY:
			return row
	
	# TODO: depois eu vejo
	return -1	 

func _on_button_click(columnIndex, button) -> void:

	# Logic
	var currentRow = _get_current_row(columnIndex)
	if game.jogada(Vector2(currentRow, columnIndex)):
		
		var evaluation: float = game.evaluate()
		
		print(evaluation)
		
		if evaluation != 0.5:
			#fim_jogo(jogador + " venceu!")
			print(game.jogador_atual() + " venceu!")
			
		elif game.empate():
			#fim_jogo("Empate!")
			print("Empate!")


		# Interface
		var circle = CIRCLE.instantiate()
		circle.position.y = buttonContainer.size.y - CIRCLE_WIDTH * (len(game.grid) - currentRow)
		#circle.get_node("Label").text = game.jogador_atual()
		circle.get_node("Color").color = game.jogador_atual()
		var column = buttonContainer.get_children()[columnIndex]
		column.add_child(circle)
		
		game.switch_player()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
