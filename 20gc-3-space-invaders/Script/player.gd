class_name Player
extends StaticBody2D

var movementSpeed : float = 400.0

# Lógica do tiro
var bulletScene : PackedScene = preload("res://Scenes/Player/bullet.tscn")
var canShoot : bool = true

func _physics_process(delta: float) -> void:
	
	skew = 0 # [EXPERIMENTAL] Reinicia a inclinação quando a nave para de se move para os lados
	
	# Detecta quando o jogador aperta para a esquerda
	if Input.is_action_pressed("left"):
		position.x -= movementSpeed * delta # Move a nave negativamente no eixo X
		skew = deg_to_rad(-15) # [EXPERIMENTAL] Enclina a nave quando vai para o lado usando magia negra ?deg_to_rad()?
	
	# Detecta quando o jogador aperta para a direita
	if Input.is_action_pressed("right"):
		position.x += movementSpeed * delta # Move a nave positivamente no eixo X
		skew = deg_to_rad(15) # [EXPERIMENTAL] Enclina a nave quando vai para o lado usando magia negra ?deg_to_rad()?
	
	position.x = clamp(position.x, 10.0, 630.0) # Limita a area que o jogador pode se mover no eixo X

# Função que detecta e lida com as entradas do jogador
func _input(event: InputEvent) -> void:
	var input = event.as_text() # Armazena o input em uma String
	
	match input: # Compara a String com as funções de cada botão
		"Space": # Se o botão pressionado for o espaço
			if canShoot: # Verifica se a nave pode atirar, e se puder
				Shoot() # Chama a função que atira

# Função que atira
func Shoot():
	canShoot = false # Marca que a nave não pode atirar 
	var bullet = bulletScene.instantiate() # Instancia a bala do tiro
	bullet.position = %GunMarker2D.global_position # Posiciona a bala na marcardo que representa a arma
	get_parent().add_child(bullet) # Pega o nodo pai e adiciona a bala como filho
	%Timer.start() # Começa o timer para que a nave possa atirar de novo

# Sinal recebido quando o tempo do timer termina
func _on_timer_timeout() -> void:
	canShoot = true # Sinaliza que a nave pode atirar novamente

# Função que lida com o dano
func Damage():
	# Lógica de dano ao jogador, deve gerenciar:
	# - A quantidade de vidas do jogador e o processo logico para controlar o game over
	# - Sistema de particulas para danos no avião
	pass
