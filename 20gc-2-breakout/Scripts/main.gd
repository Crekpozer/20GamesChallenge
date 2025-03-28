extends Node2D

var score : int = 0
var gameIsOver : bool = false
var lifes : int = 5

# Player Refrence
@onready var playerRef : StaticBody2D = %Player

# Variaveis para a maquina de estados

# PREGAME
# 	Mostra a tela de préjogo com as instruções
# 	Permite ao jogador movimentar a barra junto com a bolinha
# 	Espera a entrada do jogador para disparar a bolinha
# 	- Chama a função StartGame

# GAME
# Detecta a pontuação
# - Chama a função YOUWIN caso o jogador destrua todos os tijolos
# - Chama a função YOULOSE caso o jogador fique sem vidas

# AFTERGAME
# Mostra a tela de derrota
# - Botão para tentar de novo
# - Botão para o menu principal
# Mostra a tela de vitória
# - Botão para jogar de novo
# - Mostra botão para o menu principal

func _ready() -> void:
	# Inicializa a partida
	AudioManager.PlayBGMusic("Gameplay")

func _process(_delta: float) -> void:
	# Monitora a quantidade de tijolos para saber quantos blocos o jogador quebrou
	pass

func StartGame() -> void:
	pass

# Função que dispara quando o jogador perde a bola

# Função disparada caso o jogador ganha a partida
func YouWin() -> void:
	pass

# Função disparada quando o jogador perde a partida
func YouLose() -> void:
	pass
