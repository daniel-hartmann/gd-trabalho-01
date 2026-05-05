extends Resource
class_name GameGrid

const RED = "#ad1313"
const YELLOW = "#989532"
const EMPTY = ""

const RED_WIN = [RED, RED, RED, RED]
const YELLOW_WIN = [YELLOW, YELLOW, YELLOW, YELLOW]

@export var grid: Array
@export var jogador: String

func _init():
	self.grid = []
	
	# Initialize empty grid
	for col in range(0, 6):
		var row = []
		row.resize(7)
		row.fill(EMPTY)
		self.grid.append(row)

	self.jogador = RED

func switch_player() -> void:
	self.jogador = RED if self.jogador == YELLOW else YELLOW

func empate() -> bool:
	for linha in self.grid:
		for coluna in linha:
			if coluna == EMPTY:
				return false
	return true

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
	
	# Check rows
	for i in range(4):	
		for row in self.grid:
			if row.slice(i, i+4) in [RED_WIN, YELLOW_WIN]:
				print("horizontal win")
				eval = 1

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
			print("vertical win")
			eval = 1

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
				print("diagonal win")
				eval = 1
		

	##print("Avaliando o tabuleiro: ", self.grid)
	#for i in range(3):
		## (i,0) == (i,1) == (i,2) != EMPTY
		#if self.grid[i][0] == self.grid[i][1] and self.grid[i][1] == self.grid[i][2] and self.grid[i][2] != EMPTY:
			#eval = 1 if self.grid[i][0] == self.jogador else -1
			##print("Fim Jogo na linha: ", i, " o resultado foi: ", eval)
		#if self.grid[0][i] == self.grid[1][i] and self.grid[1][i] == self.grid[2][i] and self.grid[2][i] != EMPTY:
			#eval = 1 if self.grid[0][i] == self.jogador else -1
			##print("Fim Jogo na coluna: ", i, " o resultado foi: ", eval)
			#
	#if self.grid[0][0] == self.grid[1][1] and self.grid[1][1] == self.grid[2][2] and self.grid[2][2] != EMPTY:
		#eval = 1 if self.grid[0][0] == self.jogador else -1
		##print("Fim Jogo na diagonal principal o resultado foi: ", eval)
	#if self.grid[2][0] == self.grid[1][1] and self.grid[1][1] == self.grid[0][2] and self.grid[0][2] != EMPTY:
		#eval = 1 if self.grid[2][0] == self.jogador else -1
		##print("Fim Jogo na diagonal secundaria o resultado foi: ", eval)
	
	#if eval == 0.5:
		#print("Jogo empatado ou incompleto")
	return eval 

func jogador_atual() -> String:
	return jogador

func jogadas_possiveis() -> Array:
	var jogadas: Array = []
	for linha in range(3):
		for coluna in range(3):
			if self.grid[linha][coluna] == EMPTY:
				jogadas.append(Vector2(linha, coluna))
	return jogadas
	
func movimentar(movimento: Vector2, jogador: String) -> GameGrid:
	var lin = movimento.x
	var col = movimento.y
	
	var novo_tabuleiro = self.duplicate(true)
	novo_tabuleiro.tabuleiro[lin][col] = jogador
	return novo_tabuleiro

func valida_jogada(casa: Vector2) -> bool:
	if self.grid[casa.x][casa.y] == EMPTY:
		return true
	else:
		return false
		
func jogada(casa: Vector2) -> bool:
	if valida_jogada(casa):
		grid[casa.x][casa.y] = jogador
		return true
	return false
