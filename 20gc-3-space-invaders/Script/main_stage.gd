extends Node2D
# Esse script deve gerenciar as informações principais da partida
#
# Gameplay Esperado
# O jogador chega do menu principal, ve a animação das naves e aperta os botões para atirar e se mover,
# quando o jogador destruir toda a frota de naves inimigas o round acaba, há um curto intervalo para falar ao jogador
# que um novo round vai começar e uma nova frota aparece.
#
# Esse script irá controlar 
# - Pontuação do jogador
# - Vidas do jogador
# - Condição de vitória e derrota
# - Gerenciamento das regras do jogo

@export var fleetTemplate : PackedScene

# Quando o mapa inicia há um apresentação e depois o jogo começa, quando o jogador destroi a frota
# ha um pequeno intervalo, o sistema verifica se deve construir uma nova frota e uma nova frota é gerada.
#
# Se a vida do jogador chegar a 0 ou se a fase for concluida, uma tela de comemoração ou de gameover
# aparecerá na tela

# O jogo será baseados em rounds, quanto maior o round mais complexo o jogo fica
# Vamos criar o sistema que gerenciará os numeros, o sistema terá uma estrutura de
# replicavel caso queira criar novas fases.
# Os numeros:
# - Quantidade de rounds total dessa fase (3)
# - Round Atual
# - Atualização do valor na tela
@export_category("GameRules")
@export var totalRound : int
@export var startRound : int = 0

var actualRound : int = 0

enum GameState {STARTGAME, GAMEPLAY, INTERVAL, ENDGAME}
var actualGameState : GameState

var actualFleet
var playerScore : int = 0

# Esse é o sistema de estatistica, ele coleta informações
# durante a partida para mostrar no final.
#
# Esse script coleta:
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
var timeElapsedString

func _ready() -> void:
	actualGameState = GameState.STARTGAME
	StartIntroduction()
	
	# Configura o HUD para o contador de rounds
	%ActualRoundValueLabel.text = str(startRound)
	%TotalRoundsTextLabel.text = str(totalRound)

func _process(delta: float) -> void:
	
	if actualGameState == GameState.GAMEPLAY:
		timeElapsed += delta
		var timeElapsedInSeconds : int = floor(timeElapsed)
		var seconds: int = timeElapsedInSeconds % 60
		var minutes: int = timeElapsedInSeconds / 60
		timeElapsedString = "%02d:%02d" % [minutes, seconds]
	
	%ScoreValueLabel.text = str(playerScore)
	%TotalTimeTextLabel.text = str(timeElapsedString) 

func AddScore(amount) -> void:
	playerScore += amount * combo
	combo += 1
	%ComboValueLabel.text = str(combo)
	print(combo)
	
func AddFleet() -> void:
	print("Nova frota")
	actualFleet = null
	actualFleet = fleetTemplate.instantiate()
	actualFleet.position = %FleetMarker.position
	actualFleet.fleetDestroyed.connect(PlayInterval)
	add_child(actualFleet)

	%ActualRoundValueLabel.text = str(actualRound)
	actualGameState = GameState.GAMEPLAY

func StartIntroduction() -> void:
	actualRound += 1
	%RoundTextLabel.text = str(actualRound)
	%MainAnimationPlayer.play("RoundIntroduction")
	await %MainAnimationPlayer.animation_finished
	AddFleet()
	actualGameState = GameState.GAMEPLAY
	# Essa função leva o estado do jogo de STARTGAME para GAMEPLAY
	# Na introdução aparecerá um texto de introdução, os inimigos apareceram e o estado do jogo
	# será mudada para GAMEPLAY

# Função tocada quando a frota é destuida
func PlayInterval() -> void:
	actualRound += 1
	%RoundTextLabel.text = str(actualRound)
	actualGameState = GameState.INTERVAL
	if actualRound > totalRound:
		EndGame()
		return
	%MainAnimationPlayer.play("RoundIntroduction") # Toca a animação de transição
	%ActualRoundValueLabel.text = str(actualRound)
	await %MainAnimationPlayer.animation_finished
	actualFleet.call_deferred("queue_free")
	AddFleet() # Cria a nova frota

func EndGame() -> void:
	actualGameState = GameState.ENDGAME
	%YouWinAnimationPlayer.play("YouWin")
	%TimeTextLabel.text = str(timeElapsedString)
	%EnemiesKilledTextLabel.text = str(enemiesKilled)
	var accuracy : float = (float(enemiesKilled) / float(shotsFired)) * 100
	var accuracyString : String = "%.2f%%" % accuracy
	%ShotsFiredTextLabel.text = str(shotsFired)
	%PrecisionTextLabel.text = accuracyString
	%ScoreTextLabel.text = str(playerScore)
