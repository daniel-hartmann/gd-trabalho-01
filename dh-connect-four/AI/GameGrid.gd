extends Resource
class_name GameGrid

const RED = "#EF476F"
const YELLOW = "#F6D776"
const EMPTY = ""

const DIFFICULTY_EASY = "EASY"
const DIFFICULTY_MEDIUM = "MEDIUM"
const DIFFICULTY_HARD = "HARD"

@export var grid: Array
@export var player: String
@export var _next_player: String
@export var pesos: Array

func _init():
	self.grid = [
		[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
		[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
		[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
		[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
		[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
		[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
	]
	self.pesos = [
		[2, 5, 8, 12, 8, 5, 2],
		[5, 8, 10, 12, 10, 8, 5],
		[5, 8, 12, 15, 12, 8, 5],
		[5, 8, 12, 15, 12, 8, 5],
		[5, 8, 10, 12, 10, 8, 5],
		[2, 5, 8, 12, 8, 5, 2],
	]
	self.player = RED
	self._next_player = YELLOW

func switch_player() -> void:
	self.player = RED if self.player == YELLOW else YELLOW
	self._next_player = RED if self._next_player == YELLOW else YELLOW

func draw() -> bool:
	for coluna in self.grid[0]:
		if coluna == EMPTY:
			return false
	return true

func evaluate(dificuldade: String) -> float:
	var contador: int = 0
	var eval: float = 0.0
	
	for x in range(6, -1, -1):
		contador = 0
		for y in range(5, -1, -1):
			if self.grid[y][x] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
				eval += self.pesos[y][x]
			elif self.grid[y][x] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
				eval -= self.pesos[y][x]
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
	

	for y in range(6):
		contador = 0
		for x in range(7):
			if self.grid[y][x] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
			elif self.grid[y][x] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
	
	for y in range(5, -1, -1):
		contador = 0
		for x in range(6, -1, -1):
			if self.grid[y][x] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
			elif self.grid[y][x] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
	
	
	for y in range (2, -1, -1):
		contador = 0
		for x in range(6 - y):
			if self.grid[y + x][x] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
			elif self.grid[y + x][x] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
	
	for x in range (1, 4):
		contador = 0
		for y in range(7 - x):
			if self.grid[y][x + y] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
			elif self.grid[y][x + y] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
	
	for y in range (3, 6):
		contador = 0
		for x in range(6, 5 - y, -1):
			if self.grid[x - 6 + y][x] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
			elif self.grid[x - 6 + y][x] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
	
	for x in range (3, 6):
		contador = 0
		for y in range(5, 4 - x, -1):
			if self.grid[y][y - 5 + x] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
			elif self.grid[y][y - 5 + x] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
		
	
	for x in range (3, 6):
		contador = 0
		for y in range (x + 1):
			if self.grid[y][x - y] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
			elif self.grid[y][x - y] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
	
	for y in range (3):
		contador = 0
		for x in range (6, 6 - y, -1):
			if self.grid[6 - x + y][x] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
			elif self.grid[6 - x + y][x] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
	
	for x in range (1, 4):
		contador = 0
		for y in range (7 - x):
			if self.grid[5 - y][x + y] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
			elif self.grid[5 - y][x + y] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
	
	for y in range (3, 6):
		contador = 0
		for x in range (y + 1):
			if self.grid[y - x][x] == self.current_player():
				if contador < 0:
					contador = 0
				contador += 1
			elif self.grid[y - x][x] == self.next_player():
				if contador > 0:
					contador = 0
				contador -= 1
			else:
				eval += avaliar_match(contador, dificuldade)
				contador = 0
			if contador == 4:
				eval += 1000
			elif contador == -4:
				eval -= 1000
	
	return eval

func avaliar_match(n: int, dificuldade: String) -> float:
	if dificuldade == "DIFICIL":
		match n:
			2: return 10
			3: return 50
			4: return 1000
			-2: return -15
			-3: return -80
			-4: return -1000
			_: return 0
	elif dificuldade == "MEDIO":
		match n:
			2: return 15
			3: return 80
			4: return 1000
			-2: return -10
			-3: return -50
			-4: return -1000
			_: return 0
	else:
		match n:
			2: return 10
			3: return 50
			4: return 1000
			-2: return -10
			-3: return -50
			-4: return -1000
			_: return 0

func current_player() -> String:
	return player

func next_player() -> String:
	return _next_player

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
	
	var new_grid = self.duplicate(true)
	new_grid.grid[lin][col] = player
	return new_grid

func valida_jogada(casa: Vector2) -> bool:
	if grid[casa.x][casa.y] == EMPTY:
		return true
	else:
		return false
		
func jogada(casa: Vector2) -> bool:
	if valida_jogada(casa):
		grid[casa.x][casa.y] = player
		return true
	return false
