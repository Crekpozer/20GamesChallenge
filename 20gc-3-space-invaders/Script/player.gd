class_name Player
extends CharacterBody2D

# Parametros de movimento
var maxMovementSpeed : float = 400.0  # Velocidade de movimento
var acceleration : float = 600.0 # Aceleração
var deceleration : float = 800.0 # Desaceleração

# Lógica do tiro
var bulletScene : PackedScene = preload("res://Scenes/Player/bullet.tscn") # Cena da bala
var canShoot : bool = true # Sinaliza se o jogador pode atirar ou não

# Função toacada a todo frema que controla a fisica do personagem
func _physics_process(delta: float) -> void:
	
	# Detecta entrada do jogador
	var inputVector : Vector2 = Vector2.ZERO # Zera o Vector2
	inputVector.x = Input.get_action_strength("right") - Input.get_action_strength("left") # Aumenta e diminui o valor de x
	inputVector = inputVector.normalized() # Nunca sei o que o normalized() faz
	
	# Aceleração e desaceleração
	if inputVector != Vector2.ZERO: # Verifica se o jogador está se movendo
		velocity = velocity.move_toward(inputVector * maxMovementSpeed, acceleration * delta) # Acelera 
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta) # Desacelera
	
	# Limita a area de movimentação
	position.x = clamp(position.x, 165.0, 625.0) # Limita a area que o jogador pode se mover no eixo X
	
	# Aplica o movimento
	move_and_slide()

# Função que detecta e lida com as entradas do jogador
func _input(event: InputEvent) -> void:
	
	# Se o jogador tiver pressiona shoot
	if Input.is_action_just_pressed("shoot"):
		if canShoot: # E puder atirar
			Shoot() # Chama a função que atira

# Função que atira
func Shoot():
	canShoot = false # Marca que a nave não pode atirar 
	var bullet = bulletScene.instantiate() # Instancia a scene do tiro
	bullet.bulletDestroyed.connect(BulletDestroyed) # Conecta o signal que avisa que a bala foi destruida
	bullet.position = %GunMarker2D.global_position # Posiciona a bala na marcardo que representa a arma
	get_parent().add_child(bullet) # Pega o nodo pai e adiciona a bala como filho
	%ShootTimer.start() # Começa o timer para que a nave possa atirar de novo
	get_parent().shotsFired += 1 # informa ao sistema de estatisca que um tiro foi disparado

# Sinal recebido quando o tempo do timer termina
func _on_timer_timeout() -> void:
	canShoot = true # Sinaliza que a nave pode atirar novamente

# Função que adiciona 5 pontos a pontuação máxima quando uma bala é destruida
func BulletDestroyed() -> void:
	get_parent().AddScore(5) # Adiciona 5 pontos a pontuação máxima quando uma bala é destruida

# Função que lida com o dano
func Damage():
	# Lógica de dano ao jogador, deve gerenciar:
	# - A quantidade de vidas do jogador e o processo logico para controlar o game over
	# - Sistema de particulas para danos no avião
	get_parent().combo = 0 # Zera o combo
