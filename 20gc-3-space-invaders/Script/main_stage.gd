extends Node2D
# Esse script deve gerenciar as informações principais da partida
#
# Esse script irá controlar 
# - Pontuação do jogador
# - Vidas do jogador
# - Condição de vitória e derrota
# - Gerenciamento das regras do jogo

@export var fleetTemplate : PackedScene

# O jogo será baseados em rounds, quanto maior o round mais complexo o jogo fica
# Vamos criar o sistema que gerenciará os numeros, o sistema terá uma estrutura de
# replicavel caso queira criar novas fases.

@export_category("GameRules")
@export var totalRound : int # Total de rounds
@export var startRound : int = 0 # Round inicial

var actualRound : int = 0 # Round atual

# Maquina de estados
enum GameState {STARTGAME, GAMEPLAY, INTERVAL, ENDGAME} # Estados do jogo
var actualGameState : GameState # Variavel que irá armazenar o estado atual do jogo

var actualFleet # Tropa atual
var playerScore : int = 0 # Pontuação atual 

# - Tempo de jogo
var gameTime
# - Inimigos mortos
var enemiesKilled : int
# - Tiros disparados
var shotsFired : int = 0
# - Tiros que acertaram o inimigo
var shotsHit : int = 0
# - Precisão
var precision : float
# - Combo
var combo : int
# - Maior combo
var maxCombo : int
# - Maior pontuação
var highScore : int

# Tempo
var timeElapsed : float
# Tempo formatado em String
var timeElapsedString

# Função todaca quando o script 
func _ready() -> void:
	actualGameState = GameState.STARTGAME # Configura o estado atual do jogo para GAMESTART
	StartIntroduction() # Chama a função que toca a introdução
	
	# Configura o HUD para o contador de rounds
	%ActualRoundValueLabel.text = str(startRound)  # Atualiza o valor do round atual na HUD para 0
	%TotalRoundsTextLabel.text = str(totalRound) # Atualiza o valor total de rounds

# Função executada a todo frame
func _process(delta: float) -> void:
	
	# Checa se o estado do jogo é GAMEPLAY 
	if actualGameState == GameState.GAMEPLAY:
		timeElapsed += delta # Soma o intervalo entre os frames para uma nova variavel
		var timeElapsedInSeconds : int = floor(timeElapsed) # Usa dessa varivel para contar os segundos
		var seconds: int = timeElapsedInSeconds % 60 # Calcula os segundo
		var minutes: int = timeElapsedInSeconds / 60 # Calcula os minutos
		timeElapsedString = "%02d:%02d" % [minutes, seconds] # Monta a string para o HUD
	
	%ScoreValueLabel.text = str(playerScore) # Atualiza o valor da pontuação na tela
	%TotalTimeTextLabel.text = str(timeElapsedString) # Atualiza o tempo na tela

# Função que atualiza o valor da pontuação
func AddScore(amount) -> void:
	playerScore += amount * combo # Adiciona à pontuação o valor recebido multiplicado pelo combo
	combo += 1 # Aumenta o valor do combo em 1
	%ComboValueLabel.text = str(combo) # Atualiza o valor do combo na tela

# Função que cria uma nova frota
func AddFleet() -> void:
	actualFleet = null # Limpa a variavel para receber uma frota nova
	actualFleet = fleetTemplate.instantiate() # Instancia a nova frota
	actualFleet.position = %FleetMarker.position # Ajusta a posição da frota baseado num Mark3D
	actualFleet.fleetDestroyed.connect(PlayInterval) # Conecta a função para tocar o intervalo
	add_child(actualFleet) # Coloca a nova frota no mapa
	
	%ActualRoundValueLabel.text = str(actualRound) # Atualiza o valor do round na tela
	actualGameState = GameState.GAMEPLAY # Troca o jogo para o estado GAMEPLAY

# Toca a introdução do jogo
func StartIntroduction() -> void:
	actualRound += 1 # Aumenta o round de 0 para 1
	%RoundTextLabel.text = str(actualRound) # Atualiza o valor do round atual no HUD
	%MainAnimationPlayer.play("RoundIntroduction") # Toca a introdução no AnimationPlayer
	await %MainAnimationPlayer.animation_finished # Espera o sinal de que a animação acabou
	AddFleet() # Adiciona uma frota
	actualGameState = GameState.GAMEPLAY # Leva o estado do jogo de STARTGAME para GAMEPLAY

# Função tocada quando a frota é destuida
func PlayInterval() -> void:
	actualRound += 1 # Adiciona + 1 ao valor do round
	%ActualRoundValueLabel.text = str(actualRound) # Atualiza o valor do round atual na faixa de intervalo
	%RoundTextLabel.text = str(actualRound) # Atualiza o valor do round atual no HUD
	actualGameState = GameState.INTERVAL # Troca o estado do jogo atual para INTERVAL
	# Se o valor do round atual for maior que o total de rounds
	if actualRound > totalRound:
		EndGame() # Chama a função que finaliza o jogo
		return # Finaliza a função
	%MainAnimationPlayer.play("RoundIntroduction") # Toca a animação de transição
	await %MainAnimationPlayer.animation_finished # Espera o sinal de que a animação terminou
	actualFleet.call_deferred("queue_free") # Limpa a frota atual da memoria
	AddFleet() # Cria a nova frota

# Essa função é chamada quando a partida termina
func EndGame() -> void:
	actualGameState = GameState.ENDGAME # Troca o estado atual do game de GAMEPLAY para END 
	%YouWinAnimationPlayer.play("YouWin") # Toca a animação de vitória
	%TimeTextLabel.text = str(timeElapsedString) # Imprime o tempo da partida no painel de estatistica
	%EnemiesKilledTextLabel.text = str(enemiesKilled) # Impreme o numero de inimigos derrotados no painel de estatistica
	var accuracy : float = (float(enemiesKilled) / float(shotsFired)) * 100 # Calcula a porcentagem de acerto
	var accuracyString : String = "%.2f%%" % accuracy # Cria o valor em string
	%ShotsFiredTextLabel.text = str(shotsFired) # Imprime quantos tiros foram dados pelo jogador
	%PrecisionTextLabel.text = accuracyString # Imprime a porcentagem dos acertos no painel de estatistica
	%ScoreTextLabel.text = str(playerScore) # Imprime a pontuação na painel de estatistica
