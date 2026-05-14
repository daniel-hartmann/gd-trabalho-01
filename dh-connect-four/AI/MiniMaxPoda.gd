extends Resource
class_name MinimaxPoda

const GAME_GRID = preload("res://AI/GameGrid.gd")
const PLAY = preload("res://AI/Play.gd")

const INFINITO: int = 99999
var PROF_MAX: int = 5

func melhor_jogada(tabuleiro: GameGrid, jogador: String, dificuldade: String) -> Play:
	var jogada: Play = minimax(tabuleiro, jogador, 1, -INFINITO, INFINITO, PROF_MAX, dificuldade)
	#print("what", tabuleiro.evaluate(dificuldade))
	return jogada

func minimax(tabuleiro: GameGrid, jogador: String, profundidade: int, alfa: int, beta: int, profundidadeMax: int, dificuldade: String) -> Play:
	# Checa se o jogo acabou ou se atingiu a profundidade máxima
	var avaliacao: float = tabuleiro.evaluate(dificuldade)
	if tabuleiro.draw() or abs(avaliacao) >= 900.0 or profundidade > profundidadeMax:
		var jog: Play = PLAY.new(Vector2(), avaliacao)
		#print("FIM RECURSÃO: ", jog.avaliacao, " JOG: ", jogador, " PLAY: ", str(jog.movimento))
		return jog
	
	# Caso contrário, obtém a melhor jogada a partir dos filhos
	var melhor_jogada: Play
	var melhor_pontuacao: float
	
	if tabuleiro.current_player() == jogador:
		melhor_pontuacao = -INFINITO
	else:
		melhor_pontuacao = INFINITO
	
	# Passa por cada jogada possível
	for movimento in tabuleiro.jogadas_possiveis():
		var novo_tabuleiro: GameGrid = tabuleiro.movimentar(movimento, jogador)
					
		#print("Profundidade: ", profundidade, " tabuleiro: ", novo_tabuleiro.tabuleiro, " Jogador: ", jogador)
		var novo_jog: String = tabuleiro.RED if jogador == tabuleiro.YELLOW else tabuleiro.YELLOW
		var jogada: Play = minimax(novo_tabuleiro, novo_jog, profundidade + 1, alfa, beta, PROF_MAX, dificuldade)
		jogada.movimento = movimento
		#jogada.avaliacao = novo_tabuleiro.evaluate(dificuldade)
		
		if profundidade == 1:
			print("PLAY: ", jogada.movimento, " Avaliacao: ", jogada.avaliacao, " Profundidade: ", profundidade)
		
		# Atualiza a melhor jogada
		if tabuleiro.current_player() == jogador:
			if jogada.avaliacao > melhor_pontuacao:
				melhor_pontuacao = jogada.avaliacao
				melhor_jogada = jogada
				
				# Faz a poda na árvore
				alfa = max(alfa, melhor_pontuacao)
				if alfa >= beta:
					#print("PODA! alfa =", alfa, " beta=", beta)
					break				
		
		else:			
			if jogada.avaliacao < melhor_pontuacao:
				melhor_pontuacao = jogada.avaliacao
				melhor_jogada = jogada
				
				# Faz a poda na árvore
				beta = min(beta, melhor_pontuacao)
				if alfa >= beta:
					#print("PODA! alfa =", alfa, " beta=", beta)
					break
					
	# Retorna uma dentre as melhores jogadas
	return melhor_jogada
