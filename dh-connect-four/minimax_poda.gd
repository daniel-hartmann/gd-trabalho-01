extends Resource
class_name MinimaxPoda

const TABULEIRO = preload("res://game_grid.gd")
const JOGADA = preload("res://play.gd")

const INFINITO: int = 2

func melhor_jogada(tabuleiro: TABULEIRO, jogador: String) -> Play:
	var jogada: Play = minimax_poda(tabuleiro, jogador, -INFINITO, INFINITO)
	print("Avaliacao da melhor jogada: " + str(jogada.avaliacao))
	return jogada

func minimax_poda(
		tabuleiro: TABULEIRO, 
		jogador: String,
		alfa: int,
		beta: int
	) -> Play:
	
	# Checa se o jogo acabou ou se atingiu a profundidade maxima
	var avaliacao: float = tabuleiro.evaluate()

	if abs(avaliacao) >= 100000 or tabuleiro.empate():
		var jogada: Play = JOGADA.new(Vector2(), avaliacao)
		return jogada

	var jogada: Play
	var melhor_pontuacao: float
	var jogada_melhor: Play

	if tabuleiro.current_player() == jogador:
		melhor_pontuacao = -INFINITO
	else:
		melhor_pontuacao = INFINITO

	for movimento in tabuleiro.jogadas_possiveis():
		var novo_tabuleiro: GameGrid = tabuleiro.movimentar(movimento, jogador)
		
		var novo_jogador: String
		if jogador == tabuleiro.RED:
			novo_jogador = tabuleiro.YELLOW
		else:
			novo_jogador = tabuleiro.RED

		jogada = minimax_poda(novo_tabuleiro, novo_jogador, alfa, beta)
		jogada.movimento = movimento

		# MAX
		if tabuleiro.current_player() == jogador:
			if jogada.avaliacao > melhor_pontuacao:
				melhor_pontuacao = jogada.avaliacao
				jogada_melhor = jogada
				
				# Poda
				alfa = max(alfa, melhor_pontuacao)
				if alfa >= beta:
					print("max PODA - " + str(melhor_pontuacao))
					break
		# MIN
		else:
			if jogada.avaliacao < melhor_pontuacao:
				melhor_pontuacao = jogada.avaliacao
				jogada_melhor = jogada
				
				# Poda
				beta = min(beta, melhor_pontuacao)
				if alfa >= beta:
					print("min PODA - " + str(melhor_pontuacao))
					break

	return jogada_melhor
