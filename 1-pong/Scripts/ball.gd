extends CharacterBody2D

# A Bola
# Esse é o script da bola


var windowSize : Vector2 # O tamanho da janela
const startSpeed : int = 500 # A velocidade inicial da bola
const maxYVector : float = 0.8 
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
func NewBall():
	position.x = windowSize.x / 2
	position.y = randf_range(200, windowSize.y - 200)
	speed = startSpeed
	direction = RandomDirection()
	visible = true

# Função que randomiza a direção da bola
func RandomDirection():
	var newDirection : Vector2
	newDirection.x = [1, -1].pick_random()
	newDirection.y = randf_range(-1, 1)
	return newDirection.normalized()

# Função que trabalha com a fisica
func _physics_process(delta: float) -> void:
	
	# Move e colide o objeto com outros objetos
	var collision = move_and_collide(direction * speed * delta)
	# Variavel que vai armazenar o objeto 
	var collider
	if collision:
		%BallAnimationPlayer.play("Bounce")
		collider = collision.get_collider()
		if not inLoading:
			if isMuliplayer:
				if collider == %Player or collider == %Player2:
					speed += accel
					direction = NewDirection(collider)
					AudioManager.PlaySFX("ballHitSFX")
				else:
					direction = direction.bounce(collision.get_normal())
					AudioManager.PlaySFX("ballHitSFX")
			else:
				if collider == %Player or collider == %CPU:
					speed += accel
					direction = NewDirection(collider)
					AudioManager.PlaySFX("ballHitSFX")
				else:
					direction = direction.bounce(collision.get_normal())
					AudioManager.PlaySFX("ballHitSFX")
		else:
				direction = direction.bounce(collision.get_normal())

# Gera uma nova direção aleatório para a bola
func NewDirection(collider):
	var ballY = position.y
	var padY = collider.position.y
	var dist = ballY - padY
	var newDirection := Vector2()
	
	if direction.x > 0:
		newDirection.x = -1
	else:
		newDirection.x = 1
	
	newDirection.y = (dist / (collider.paddleHeight / 2)) * maxYVector
	
	return newDirection.normalized()
