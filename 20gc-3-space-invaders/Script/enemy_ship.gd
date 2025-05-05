class_name Enemy
extends StaticBody2D

# Quando essa nave morre, ela manda um sinal para a linha avisando que ele morreu, a linha vai
# avisar a frota que ele morreu,e quando a linha toda morrer, o jogador ganha 50 pontos, quando todas
# as linhas morrerem, a frota morre e o script principal irá gerar outra frota.

# Ele emite esse signal quando morre, passando quantos pontos o jogador vai ganhar
signal enemyDied(points)

# O inimigo conta com um sistema aleatório de sprites e operação, o que vai permitir ter naves
# de varios tipos e sprites diferentes de forma aleatória e quem sabe um sistema de chance de aparição
# de naves de tipos diferentes

# Essa variavel marca se a nave irá funcionar ou não.
# Ela vem por padrão verdadeiro, assim que a partida começar
# ela vai:
#  1. Decidir se o inimigo irá aparecer ou não, cria espaços vazis na frota
#  2. Qual será o seu Sprite
#  3. Aplicar esse Sprite
# 
# Se ela for falsa, a lógica será suspensa e a nave nem aparecerá
@export var isActive: bool = true

# Depois de se configurar, irá enviar um sinal para a frota para avisar se ele pode ou não ser
# contado como um inimigo válido
signal enemyReady()

# Gerenciamento de Sprites
var shipSprites : Array = ["res://Addons/kenney_pixel-shmup/Ships/ship_0012.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0013.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0014.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0015.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0016.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0017.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0018.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0019.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0020.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0021.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0022.png",
 "res://Addons/kenney_pixel-shmup/Ships/ship_0023.png"] # Lista de sprites possiveis para o avião
var selectedSprite : String # Variavel que irá armazernar o endereço do sprite

# Lógica do tiro
@export_category("Fire Logic")
@export var bulletScene : PackedScene = preload("res://Scenes/Enemies/EnemyBullet.tscn") # Referencia do nodo do tiro
@export var canShoot : bool = false # Sinaliza se pode atirar ou não
@export var fireChance : float = 0.7 # Chance do inimigo atirar, quanto menor o valor, menos chance de atirar
# Lógica do interalo dos tiros
# Essa lógica existe para que os inimigos parem de atirar ao mesmo tempo 
@export var minFireInterval : float = 1.8 # Intervalo minimo entre tiros (em seg.)
@export var maxFireInterval : float = 2.8 # Intervalo máximo entre tiros (em seg.)
@export var fireInterval : float # Tempo que o inimigo levará para poder atirar de novo

# Particulas
@onready var smokeParticle : CPUParticles2D = %SmokeParticles2D

var deathTween : Tween

#region Essa é uma região
#endregion

# Função tocada uma vez no inicio
func _ready() -> void:
	pass

# Função que lida com o tiro
func Shoot():
	if canShoot: # Se o inimigo puder atirar...
		canShoot = false # Sinaliza que o inimigo não pode atirar
		var bullet = bulletScene.instantiate() # Instancia a bala do inimigo
		bullet.global_position = %GunMarker.global_position # Posiciona a bala
		get_tree().get_root().add_child(bullet) # Adiciona à arvore da cena
		%ShotTimer.wait_time = randf_range(minFireInterval, maxFireInterval) # Calcula o tempo de intervalo
		%ShotTimer.start() # Ativa o timer para poder atirar de novo

# Função chamada quando o timer da recarga do tiro termina
func _on_shot_timer_timeout() -> void:
	var roll = randf_range(0, 1) # Sorteia entre 0 e 1 para atirar ou não de acordo com a chance de tiro
	canShoot = true # Sinaliza que o inimigo pode atirar novamente
	
	# Se o valor do sorteio for maior que a chance de tiro...
	if roll >= fireChance:
		Shoot() # Chama a função que atira
		return # Retorna, pois o timer vai ser reiniciado pela função que atira
	
	%ShotTimer.start() # Reinicia o timer

# Função tocada quando o inimigo morre
func Death():
	# Essa função vai ser responsavel por lidar com a morte do inimigo
	# - Desliga a detecção da area do colisão
	%CollisionShape2D.queue_free()
	# - Para a contagem para o proximo tiro
	%ShotTimer.stop()
	# - Dispara um sinal que atualiza a contagem de inimigos vivos e a pontuação
	emit_signal("enemyDied", 10)
	# - Dispara a animação de morte e as paticulas de destroços fogo e fumaça
	z_index = 0
	rotation += randf_range(-0.3, 0.3)
	var smokePosition : Vector2 = [%SmokePositionMarker.position, %SmokePositionMarker2.position, %SmokePositionMarker3.position].pick_random()
	%SmokeParticles2D.position = smokePosition
	%EnemyShipAnimationPlayer.play("hit")
	await %EnemyShipAnimationPlayer.animation_finished
	queue_free()

# Essa função vai inicializar o processo de geração do avião e avisar à frota que a nave está pronta
# e pode ser registrada como um inimigo válido
func Initialize() -> void:
	# print("Inicializando nave")
	# Se a nave estiver ativa
	if isActive: 
		#print("nave ativa por padrão")
		var active = [0, 1].pick_random() # Escolhe entre 0 e 1 para decidir se ativa ou não a nave
		# Se a nave não estiver ativas
		if active == 0: 
			# print("Nave descartada")
			queue_free() # Se Remove de cena
		else: # Se a nave estiver ativa
			# print("Nave ativada")
			var shipIndex = randi_range(0, shipSprites.size() - 1) # Escolhe o index de um sprite da lista
			selectedSprite = shipSprites[shipIndex] # Seleciona o Sprite daquele index
			%ShipSprite.texture = load(shipSprites[shipIndex]) # Aplica a textura do sprites
			emit_signal("enemyReady", self)
	# else:
		# print("Nave inativa por padrão")
