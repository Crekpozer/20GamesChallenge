extends Node2D

@export_category("Game Rules")
@export var lifes : int = 3 # Quantidade de vidas do jogador 
@export var totalBricks : int = 30 # O total de tijolos na tela

var score : int = 0 # Pontuação do jogador
var gameIsOver : bool = false # Marca se o jogo acabou ou não
var highScore : int # Pontuação recorde do jogador

@onready var playerRef : StaticBody2D = %Player # Referencia ao jogador
@onready var ballRef : CharacterBody2D = %Ball # Referencia da bola

# Função tocada quando o jogo começa
func _ready() -> void:
	# Inicializa a partida
	LoadHighScore() # Carrega e exibe a pontuação maxima
	AudioManager.PlayBGMusic("Gameplay") # Toca a musica de fundo
	%LifesText.text = str(lifes) # Imprime as vidas na tela
	%ScoreText.text = str(score) # Imprime a pontuação na tela

# Função que a atualiza a todo frame 
func _process(_delta: float) -> void:
	
	# Se o jogo não estriver acabado
	if not gameIsOver:
		# Se as vidas for 0
		if lifes == 0:
			# Você perde a partida
			YouLose() # Função que chama a tela de derrota
			%PlayTouchScreenButton.visible = false
		# ou se o total de tijolos restante
		elif totalBricks == 0:
			# Você ganha a partida
			YouWin() # Função que chama a tela de vitória
			%PlayTouchScreenButton.visible = false
	
	%ScoreComboText.text = str(ballRef.combo)

# Função disparada quando o jogador ganha a partida
func YouWin() -> void:
	%EndGameAnimationPlayer.play("win") # Anima o texto de vitória
	gameIsOver = true # Sinaliza que o jogo acabou
	%PlayTouchScreenButton.visible = false
	# AudioManager.PlayBGMusic("Victory")
	
	# Verifica se a pontuação atingida é maior que a pontuação maxima
	if score > highScore: 
		SetNewHighScore() # Salva a nova pontuação

# Função disparada quando o jogador perde a partida
func YouLose() -> void:
	gameIsOver = true # Marca que a partida já acabou
	%EndGameAnimationPlayer.play("lose") # Toca a animação de derrota
	# AudioManager.PlayBGMusic("Defeated") # Toca a musica de derrota
	%PlayTouchScreenButton.visible = false

# Função chamada quando o jogar bate o ultimo record
func SetNewHighScore():
	# Variavel que irá armazenar o novo recorde no arquivo
	var file = FileAccess.open("user://breakout.txt", FileAccess.WRITE)
	highScore = score # atualiza o valor da varivel que armazena o recorde
	file.store_string(str(highScore)) # usa a varivel para escrever no arquivo
	%HighScoreText.text = str(highScore) # Atauliza o valor na tela da pontuação recorde

# Função que carrega o ultimo recorde do arquivo
func LoadHighScore() -> void:
	# Variavel que irá carregar o recorde do arquivo
	var file = FileAccess.open("user://breakout.txt", FileAccess.READ)
	highScore = file.get_as_text(true).to_int() # Atualiza o valor de recorde para o valor carregado do arquivo
	%HighScoreText.text = str(highScore) # Atauliza o valor na tela da pontuação recorde

# Função que dispara quando o jogador perde a bola
func _on_ball_pass_through_body_entered(body: Node2D) -> void:
	lifes -= 1 # Reduz uma vida do jogador
	%LifesText.text = str(lifes) # Atualiza o valor da quantidade de vidas na tela
	
	# Se o jogo ainda não tiver acabado
	if not gameIsOver:
		%PlayTouchScreenButton.visible = true
		playerRef.ResetBall() # Posiciona uma nova bola para o jogador
