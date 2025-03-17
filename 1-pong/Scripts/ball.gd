extends CharacterBody2D

var windowSize : Vector2 # O tamanho da janela
const startSpeed : int = 500 # A velocidade inicial da bola
const maxYVector : float = 0.8 
var accel : int = 50 # O quanto a bola acelera
var speed : int # A velocidade atual da bola
var direction : Vector2 # A direção da bola

func _ready():
	windowSize = get_viewport_rect().size

# Função que randomiza a posição e a direção inicial da bola
func NewBall():
	position.x = windowSize.x / 2
	position.y = randf_range(200, windowSize.y - 200)
	speed = startSpeed
	direction = RandomDirection()
	visible = true

func RandomDirection():
	var newDirection : Vector2
	newDirection.x = [1, -1].pick_random()
	newDirection.y = randf_range(-1, 1)
	return newDirection.normalized()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * speed * delta)
	var collider
	if collision:
		%BallAnimationPlayer.play("Bounce")
		collider = collision.get_collider()
		if collider == %Player or collider == %CPU:
			speed += accel
			direction = NewDirection(collider)
		else:
			direction = direction.bounce(collision.get_normal())


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
