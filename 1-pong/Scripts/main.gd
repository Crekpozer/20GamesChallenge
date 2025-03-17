extends Node2D

var score : Array = [0,0] #0:Player 1:CPU
const paddleSpeed : int = 500
var gameIsOver : bool = false

# Player Refrence
@onready var playerRef : StaticBody2D = %Player

# Variaveis para a maquina de estados
enum GameState{PREGAME,GAME,INTERVAL,AFTERGAME}
var currentGameState : GameState

# PREGAME
# 	Mostra a tela de préjogo com as dicas
# 	Espera pela entrada do jogador
# 	Toca a animação de entrada na partida
# 	- Esmaece a tela de préjogo
# 	- Mostra o placar
# 	- Traz a contagem regressiva
# 	- Chama a função StartGame

# GAME
# Detecta a pontuação
# - Chama a função YOUWIN em caso de fazer um ponto
# - Chama a função YOULOSE em caso de derrota

# AFTERGAME
# Mostra a tela de derrota
# - Botão para tentar de novo
# - Mostra botões para o bluesky e github
# Mostra a tela de vitória
# - Botão para jogar de novo
# - Mostra botões para o bluesky e github

@onready var animationPlayer : AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	# Inicializa a partida
	currentGameState = GameState.PREGAME

func _input(event: InputEvent) -> void:
	# Espera o comando do jogador para iniciar a contagem para a partida
	if event.is_pressed() && currentGameState == GameState.PREGAME:
		# Chama a função que inicia o processo de começar o jogo
		StartGame()

func _process(_delta: float) -> void:
	# Monitora o placar da partida para saber qual tela mostrar
	if score[0] == 1:
		# Chama a função que tras as comemorações da vitória
		YouWin()
	elif score[1] == 3:
		# Chama a função que lementa a derrota
		YouLose()

func StartGame() -> void:
	# Toca a transição da tela de pré-jogo
	%PreGameAnimationPlayer.play("TransitionToGame")
	# Espera a animação terminar
	await %PreGameAnimationPlayer.animation_finished
	# Muda o estado atual do jogo de pré-jogo para jogo
	currentGameState = GameState.GAME
	# Indica ao jogador que a partida começou
	playerRef.gameHasStarted = true
	# Dispara uma bola nova
	%Ball.NewBall()

# Timer da bola, serve para disparar uma nova bola após um intervalo
func _on_ball_timer_timeout() -> void:
	# Se o jogo ainda não tiver acabado...
	if not gameIsOver:
		# Dispara uma nova bola
		%Ball.NewBall()

# Função disparada quando a bola entra na Area2D da esquerda, marca um ponto para a IA
func _on_score_left_body_entered(_body: Node2D) -> void:
	# Acessa e aumenta a pontuação da IA em 1
	score[1] += 1
	# Atualiza o valor do texto na tela
	%ScoreCPU.text = str(score[1])
	# Se o jogo ainda não tiver acabado...
	if not gameIsOver:
		# Dispara o timer para uma nova bola
		%BallTimer.start()

# Função disparada quando a bola entra na Area2D da direita, marca um ponto para o jogador
func _on_score_right_body_entered(_body: Node2D) -> void:
	# Acessa e aumenta a pontuação do jogador em 1
	score[0] += 1
	# Atualiza o valor do texto na tela
	%ScorePlayer.text = str(score[0])
	# Se o jogo ainda não tiver acabado...
	if not gameIsOver:
		# Dispara o timer para uma nova bola
		%BallTimer.start()

# Função disparada caso o jogador ganha a partida
func YouWin() -> void:
	# Desativa a função _process
	set_process(false)
	# Toca a comemoração de vitória
	animationPlayer.play("YOUWIN")
	# Altera a variavel que indica que o jogo acabou
	gameIsOver = true
	# Altera o estado do jogo para pós-jogo
	currentGameState = GameState.AFTERGAME
	# Avisa ao jogador que o jogo acabou
	playerRef.gameHasStarted = false

# Função disparada quando o jogador perde a partida
func YouLose() -> void:
	# Desativa a função _process
	set_process(false)
	# Toca a lamentação de derrota
	animationPlayer.play("YOULOSE")
	# Altera a variável que indica que o jogo acabou
	gameIsOver = true
	# Altera o estado atual do jogo para pós-jogo
	currentGameState = GameState.AFTERGAME
	# Avisa ai jogador que o jogo acabou
	playerRef.gameHasStarted = false
