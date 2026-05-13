extends Resource
class_name GameGrid

const RED = "#EF476F"
const YELLOW = "#F6D776"
const EMPTY = ""

const RED_3 = [RED, RED, RED]
const YELLOW_3 = [YELLOW, YELLOW, YELLOW]

const RED_WIN = [RED, RED, RED, RED]
const YELLOW_WIN = [YELLOW, YELLOW, YELLOW, YELLOW]

@export var grid: Array
@export var player: String

func _init():
	self.grid = []
	
	# Initialize empty grid
	for col in range(0, 6):
		var row = []
		row.resize(7)
		row.fill(EMPTY)
		self.grid.append(row)

	self.player = RED

func switch_player() -> void:
	self.player = RED if self.player == YELLOW else YELLOW

func empate() -> bool:
	for column in self.grid[0]:
		if column == EMPTY:
			return false
	return true


#func evaluate() -> float:
	#var score := 0.0
#
	## Center column preference
	#for row in range(6):
		#if grid[row][3] == RED:
			#score += 6
		#elif grid[row][3] == YELLOW:
			#score -= 6
#
	## Horizontal
	#for row in range(6):
		#for col in range(4):
			#score += evaluate_window([
				#grid[row][col],
				#grid[row][col + 1],
				#grid[row][col + 2],
				#grid[row][col + 3],
			#])
#
	## Vertical
	#for row in range(3):
		#for col in range(7):
			#score += evaluate_window([
				#grid[row][col],
				#grid[row + 1][col],
				#grid[row + 2][col],
				#grid[row + 3][col],
			#])
#
	## Diagonal \
	#for row in range(3):
		#for col in range(4):
			#score += evaluate_window([
				#grid[row][col],
				#grid[row + 1][col + 1],
				#grid[row + 2][col + 2],
				#grid[row + 3][col + 3],
			#])
#
	## Diagonal /
	#for row in range(3, 6):
		#for col in range(4):
			#score += evaluate_window([
				#grid[row][col],
				#grid[row - 1][col + 1],
				#grid[row - 2][col + 2],
				#grid[row - 3][col + 3],
			#])
#
	#return score
#
#func evaluate_window(window: Array) -> float:
	#var red_count := window.count(RED)
	#var yellow_count := window.count(YELLOW)
	#var empty_count := window.count(EMPTY)
#
	## RED wins
	#if red_count == 4:
		#return 100000
#
	## YELLOW wins
	#if yellow_count == 4:
		#return -100000
#
	## RED threats
	#if red_count == 3 and empty_count == 1:
		#return 100
#
	#if red_count == 2 and empty_count == 2:
		#return 10
#
	## YELLOW threats
	#if yellow_count == 3 and empty_count == 1:
		#return -100
#
	#if yellow_count == 2 and empty_count == 2:
		#return -10
#
	#return 0

func evaluate() -> float:
	var eval: float = 0.5
	
	"""
	[
		| 0, 0 | 0, 1 | 0, 2 | 0, 3 | 0, 4 | 0, 5 | 0, 6 |
		| 1, 0 | 1, 1 | 1, 2 | 1, 3 | 1, 4 | 1, 5 | 1, 6 |
		| 2, 0 | 2, 1 | 2, 2 | 2, 3 | 2, 4 | 2, 5 | 2, 6 |
		| 3, 0 | 3, 1 | 3, 2 | 3, 3 | 3, 4 | 3, 5 | 3, 6 |
		| 4, 0 | 4, 1 | 4, 2 | 4, 3 | 4, 4 | 4, 5 | 4, 6 |
		| 5, 0 | 5, 1 | 5, 2 | 5, 3 | 5, 4 | 5, 5 | 5, 6 |
	]
	"""
	# Check draw
	
	# Check rows
	for i in range(4):	
		for row in self.grid:
			if row.slice(i, i+4) in [RED_WIN, YELLOW_WIN]:
				#print("horizontal win")
				return 100000

	# Check cols
	for i in range(6):
		if [
			self.grid[0][i],
			self.grid[1][i],
			self.grid[2][i],
			self.grid[3][i],
		] in [RED_WIN, YELLOW_WIN] or [
			self.grid[1][i],
			self.grid[2][i],
			self.grid[3][i],
			self.grid[4][i],
		] in [RED_WIN, YELLOW_WIN] or [
			self.grid[2][i],
			self.grid[3][i],
			self.grid[4][i],
			self.grid[5][i],
		] in [RED_WIN, YELLOW_WIN]:
			#print("vertical win")
			return 100000

	# Check diagonals
	for i in range(3):
		for j in range(4):
			if [
				self.grid[i][j],
				self.grid[i+1][j+1],
				self.grid[i+2][j+2],
				self.grid[i+3][j+3],
			] in [RED_WIN, YELLOW_WIN] or [
				self.grid[i][j],
				self.grid[i+1][j-1],
				self.grid[i+2][j-2],
				self.grid[i+3][j-3],
			] in [RED_WIN, YELLOW_WIN]:
				#print("diagonal win")
				return 100000

	return eval

func current_player() -> String:
	return player

func jogadas_possiveis() -> Array:
	var jogadas: Array = []

	for col in range(7):
		for row in range(5, -1, -1):
			if grid[row][col] == EMPTY:
				jogadas.append(Vector2(row, col))
				break

	return jogadas
	
func movimentar(movimento: Vector2, player: String) -> GameGrid:
	var lin = movimento.x
	var col = movimento.y

	var novo_tabuleiro = self.duplicate(true)
	novo_tabuleiro.grid[lin][col] = player

	return novo_tabuleiro

func valida_jogada(casa: Vector2) -> bool:
	if self.grid[casa.x][casa.y] == EMPTY:
		return true
	else:
		return false
		
func jogada(casa: Vector2) -> bool:
	if valida_jogada(casa):
		grid[casa.x][casa.y] = player
		return true
	return false
