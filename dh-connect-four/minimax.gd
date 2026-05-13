extends Resource
class_name Minimax

const GAME_GRID = preload("res://game_grid.gd")
const PLAY = preload("res://play.gd")


func melhor_jogada(tabuleiro: GAME_GRID, jogador: String, profundidade_maxima: int) -> Play:
	var jogada: Play = minimax(tabuleiro, jogador, profundidade_maxima, 0)
	return jogada

func minimax(
		tabuleiro: GAME_GRID, 
		jogador: String,
		profundidade_maxima: int,
		profundidade: int
	) -> Play:
	
	# Checa se o jogo acabou ou se atingiu a profundidade maxima
	var avaliacao: float = tabuleiro.evaluate()

	if abs(avaliacao) >= 100000 or tabuleiro.empate() or profundidade == profundidade_maxima:
		var jogada: Play = PLAY.new(Vector2(), avaliacao)
		return jogada
		
	var jogada: Play
	var melhor_pontuacao: float
	var melhores_jogadas: Array = []
	
	if tabuleiro.current_player() == jogador:
		melhor_pontuacao = -INF
	else:
		melhor_pontuacao = INF
	

	for movimento in tabuleiro.jogadas_possiveis():
		var novo_tabuleiro: GameGrid = tabuleiro.movimentar(movimento, jogador)
		
		var novo_jogador: String
		if jogador == tabuleiro.RED:
			novo_jogador = tabuleiro.YELLOW
		else:
			novo_jogador = tabuleiro.RED
		
		jogada = minimax(novo_tabuleiro, novo_jogador, profundidade_maxima, profundidade + 1)
		jogada.movimento = movimento
		
		# MAX
		if tabuleiro.current_player() == jogador:
			if jogada.avaliacao > melhor_pontuacao:
				melhor_pontuacao = jogada.avaliacao
				melhores_jogadas = []
				melhores_jogadas.append(jogada)
			elif jogada.avaliacao == melhor_pontuacao:
				melhores_jogadas.append(jogada)
		
		# MIN
		else:
			if jogada.avaliacao < melhor_pontuacao:
				melhor_pontuacao = jogada.avaliacao
				melhores_jogadas = []
				melhores_jogadas.append(jogada)
			elif jogada.avaliacao == melhor_pontuacao:
				melhores_jogadas.append(jogada)
		
	
	#print("tamanho de melhores jogadas: " + str(len(melhores_jogadas)))

	# Retorna a melhor jogada
	melhores_jogadas.shuffle()
	return melhores_jogadas[0]
