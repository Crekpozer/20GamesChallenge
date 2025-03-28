extends CharacterBody2D

# A Bola
# Esse é o script da bola

var windowSize : Vector2 # O tamanho da janela
const startSpeed : int = 500 # A velocidade inicial da bola
const maxXVector : float = 0.8 
var accel : int = 50 # O quanto a bola acelera
var speed : int # A velocidade atual da bola
var direction : Vector2 # A direção da bola


# Essas variaveis alteram o código para que a bola se comporte da forma correta
# tanto dentro do loading como no modo multiplayer
@export var inLoading : bool = false
@export var isMuliplayer : bool = false

func _ready():
	# Detecta o tamanho da tela
	windowSize = get_viewport_rect().size

# Função que randomiza a posição e a direção inicial da bola
func NewBall(initialPosition : Vector2):
	position = initialPosition
	speed = startSpeed
	direction = RandomDirection()
	visible = true

# Função que randomiza a direção da bola
func RandomDirection():
	var newDirection : Vector2
	newDirection.x = 0
	newDirection.y = -1
	return newDirection.normalized()

# Função que trabalha com a fisica
func _physics_process(delta: float) -> void:
	
	# Move e colide o objeto com outros objetos
	var collision = move_and_collide(direction * speed * delta)
	# Variavel que vai armazenar o objeto 
	var collider
	if collision:
		collider = collision.get_collider()
		if not inLoading:
			if collider == %Player:
				speed += accel
				direction = NewDirection(collider)
				AudioManager.PlaySFX("ballHitSFX")
			elif collider is Brick:
				direction = direction.bounce(collision.get_normal())
				AudioManager.PlaySFX("ballHitSFX")
				collider.queue_free()
			else:
				direction = direction.bounce(collision.get_normal())
				AudioManager.PlaySFX("ballHitSFX")
		else:
				direction = direction.bounce(collision.get_normal())

# Gera uma nova direção aleatório para a bola
func NewDirection(collider):
	var ballX = position.x
	var padX = collider.position.x
	var dist = ballX - padX
	var newDirection := Vector2()
	
	if direction.y > 0:
		newDirection.y = -1
	else:
		newDirection.y = 1
	
	newDirection.x = (dist / (collider.paddleWidth / 2)) * maxXVector
	
	return newDirection.normalized()
