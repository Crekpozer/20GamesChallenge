extends CharacterBody2D
class_name Ball

# A Bola
# Esse é o script da bola

var windowSize : Vector2 # O tamanho da janela
const startSpeed : int = 500 # A velocidade inicial da bola
const maxXVector : float = 0.8
var accel : int = 15 # O quanto a bola acelera
var speed : int # A velocidade atual da bola
var direction : Vector2 # A direção da bola

var combo : int # Multiplicador de pontuação

# Essas variaveis alteram o código para que a bola se comporte da forma correta
# tanto dentro do loading como no modo multiplayer
@export var inLoading : bool = false
@export var isMuliplayer : bool = false

var particles : CPUParticles2D

# Função tocada quando o jogo começa
func _ready():
	# Detecta a largura da tela
	windowSize = get_viewport_rect().size
	# Referencia do missor da particulas da bola
	particles = %CPUParticles

# Função que gerencia a fisica da bola
func _physics_process(delta: float) -> void:
	
	# Move e colide o objeto com outros objetos
	var collision = move_and_collide(direction * speed * delta)
	# Variavel que vai armazenar o objeto com que a bola está colidindo
	var collider
	
	# Se a bola estiver colidindo
	if collision:
		# Armazena o objeto com que a bola está colidindo
		collider = collision.get_collider()
		# Se essa bola não estiver na tela de carregamento
		if not inLoading:
			# Se a bola tiver colidindo com...
			if collider == %Player: # O jogador
				combo = 1
				direction = NewDirection(collider) # Altera a direção da bola
				AudioManager.PlaySFX("ballHitSFX", combo) # Toca o audio da colisão da bola
			# Ou se for um tijolo...
			elif collider is Brick:
				speed += accel # Acelera a bola
				combo += 1 # Aumenta o combo em 1
				particles.direction = direction
				particles.emitting = true
				get_parent().score += 10 * combo # Aumenta a pontuação em 10 multiplicado pelo combo
				get_parent().totalBricks -= 1 # Diminui a quantidade total de tijolos
				%ScoreText.text = str(get_parent().score) # Atualiza o valor da pontuação
				direction = direction.bounce(collision.get_normal()) # Usa .bounce para calcular a nova direção da bola
				AudioManager.PlaySFX("ballHitSFX", combo) # Toca o audio de colisão da bola
				collider.queue_free() # Elimina o tilojo da memória
				print("Tijolos restantes ", get_parent().totalBricks) # [DEBUG] imprime na tela a quantidade atual de tijolos
			# Senão
			else:
				direction = direction.bounce(collision.get_normal()) # Usa .bounce para calcular a nova direção da bola
				AudioManager.PlaySFX("ballHitSFX", combo + 1) # Toca o audio de colisão da bola
		# Se a bola estiver na tela de carregamento
		else:
				direction = direction.bounce(collision.get_normal()) # Usa .bounce para calcular a nova direção da bola

# Função que randomiza a posição e a direção inicial da bola
func NewBall(initialPosition : Vector2):
	position = initialPosition # Define a posição inicial da bola 
	speed = startSpeed # Defini a velocidade inicial da bola
	direction = RandomDirection() # Define uma direção aleatória para a bola
	visible = true # Deixa ela visivel

# Função que randomiza a direção da bola
func RandomDirection():
	var newDirection : Vector2 # Variavél que será a nova direção da bola
	newDirection.x = 0 # Define a direção no eixo x
	newDirection.y = -1 # Define a direção no eixo y
	return newDirection.normalized() # Retorna a variavel com valores normalizados

# Gera uma nova direção aleatório para a bola levando em consideração o objeto com quem ele colidiu 
func NewDirection(collider):
	var ballX = position.x # Variavel que irá armazenar a posição da bola no eixo x
	var padX = collider.position.x # Variavel que irá armazenar a posição da barra no eixo x
	var dist = ballX - padX # Variavel que irá calcular a distancia entre a bola e a barra.
	var newDirection := Vector2() # Variavel que será a nova direção da bola
	
	# Se a bola estiver, no eixo Y, menor que 0 (subindo)
	if direction.y > 0:
		newDirection.y = -1 # Configura para que ele seja -1 (descendo)
	# Senão
	else:
		newDirection.y = 1 # Configura para que ele seja 1 (subindo)
	
	# Para o eixo X, vamos calcular a distancia do objeto que ele colidiu dividido por 2, vezes o valor maximo de inclinação
	# Isso faz com a bola leve em consideração o quão perto das bordas da barra ela está para decidir o quão inclinada ela vai ser
	newDirection.x = (dist / (collider.paddleWidth / 2)) * maxXVector
	
	return newDirection.normalized() # Retorna o novo valor de direção normalizado
