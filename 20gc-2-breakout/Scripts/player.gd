extends StaticBody2D

var windowWidth : float # Altura da janela
var paddleWidth : float # Altura da barra

var ballRef : CharacterBody2D # Referencia da bola
var ballLaunched : bool = false # Marca se a bola já foi lançada

# var hasPressedAction : bool = false
# var isTipsOn : bool = true

var paddleSpeed : int = 400 # Velocidade da barra

# Função tocada quando o jogo começa
func _ready():
	windowWidth = get_viewport_rect().size.x # Armazena o tamanho do eixo x da tela
	paddleWidth = %ColorRect.size.x # Armazena o tamanho da barra no eixo x
	ballRef = %Ball # Armazena a referrencia da bola

# Função tocada a todo frame
func _process(delta: float) -> void:
	
	# Acessa o nodo pai para verificar se a partida já acabou
	if not get_parent().gameIsOver:
		# Se o jogador tiver pressionado o botão para a esquerda (W)
		if Input.is_action_pressed("left1"):
			# hasPressedAction = true
			position.x -= paddleSpeed * delta # Altera a posição da barra, negativamente, no eixo X
		# Ou se o jogador estiver pressionando para a direita
		elif Input.is_action_pressed("right1"): 
			# hasPressedAction = true
			position.x += paddleSpeed * delta # Altera a posição da barra, positivamente, no eixo X
	
	# Limitar a posição da barra na janela
	position.x = clamp(position.x, paddleWidth / 2 + 10, windowWidth - paddleWidth / 2 - 10) 

# Função responsavel por detectar as entradas do jogador
func _input(event: InputEvent) -> void:
	var input = event.as_text() # Armazena o evento da entrada como um texto
	
	# Acessa o nodo pai para verificar se o jogo não acabou 
	if not get_parent().gameIsOver:
		# Deverifica se a entreda do jogador batem com algumas das funções
		match input:
			"Space": # Se a entrada for ESPAÇO, ele lançara a bola
				if not ballLaunched: # Se o bola ainda não tiver sido lançada
					ballLaunched = true # Marca que a bola foi lançada
					%BallSprite2D.visible = false # Mostra a bola
					ballRef.NewBall(%BallSprite2D.global_position) # Posiciona a bola no mesmo lugar que o sprite na barra
					ballRef.visible = true # Torna o sprite da bola na barra invisivel

# Função que reseta a posição da bola após perder ela
func ResetBall() -> void:
	ballLaunched = false # Marca a bola como não lançada
	%BallSprite2D.visible = true # Torna o sprite da bola da barra visivel
	ballRef.visible = false # Torna a bola fisica invisivel
