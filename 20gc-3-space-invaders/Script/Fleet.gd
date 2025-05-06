class_name Fleet
extends Node2D

# Esse é o script da frota, ele é responsavel por gerenciar as naves e seus sinais.

# Esse script:
# 1. Se conecta a todos os espaços de naves e executa a inicialização do espaço
# 2. Espera a inicialização terminar e registra as naves ativas, conectando nelas os sinais necessarios

# Quando toda a frota for destruida esse sinal será emitido
signal fleetDestroyed

# Essas variaveis são usadadas para controlar o tamanho da frota
var totalEnemies : int = 0
# e quanto da frota já foi destruido
var enemiesAlive : int = 0

var fleetPoints : int = 50

# Função que toca no inicio 
func _ready() -> void:
	for row in get_children(): # Procura por linhas
		for enemy in row.get_children(): # Procura por inimigos dentro de cada linha
			if enemy is Enemy: # Se o inimigo for do tipo Enemy
				enemy.enemyReady.connect(EnemyReady) # Conecta o sinal para receber a confirmação da nave
				enemy.Initialize() # inicializa o inimigo
	
	# Seleciona com qual animação a frota vai entrar
	%FleetAnimationPlayer.play(["Respawn3", "Respawn2", "Respawn1"].pick_random())
	await %FleetAnimationPlayer.animation_finished # Espera até a animação de introdução acabar
	%FleetAnimationPlayer.play("BattleLoop") # Toca a animação do looping de batalha

# Função que toca a todo frame
func _process(delta: float) -> void:
	# Atualiza o total de inimigos nessa frota e quantos inimigos já foram destruidos
	%totalLabel.text = "Total: {0} | Restantes: {1}".format([totalEnemies, enemiesAlive])

# Função chamada quando um inimigo morre
func EnemyDied(points):
	# print("Inimigo morto. + {0} pontos".format([points]))
	enemiesAlive -= 1 # Aumenta o valor de inimigos atual mortos em 1
	get_parent().AddScore(points) # Altera a pontuação no script principal que controla isso
	if enemiesAlive == 0: # Se o numero de inimigos vivos for menor ou igual a zero...
		print("Todos os inimigos da frota foram destruídos. + {0} pontos".format([fleetPoints])) # [DEBUG] Emite no console uma mensagem de que a frota foi destruida.
		get_parent().AddScore(fleetPoints) # Adiciona à pontuação geral, os pontos ganhos por destruir a frota toda
		emit_signal("fleetDestroyed") # Emite o sinal para avisar que a frota foi destruida

# Função chamada quando a nave avisa que está pronta
func EnemyReady(emitter: Node):
	# print("Sinal recebido de: ", emitter)
	totalEnemies += 1 # Aumenta o numero de naves registradas
	enemiesAlive += 1 # Aumenta o numero de naves vivas
	print("Inimigo registrado. Total de inimigos: ", totalEnemies)
	emitter.enemyDied.connect(EnemyDied) # Conecta a função que ativa quando o inimigo morre ao sinal
