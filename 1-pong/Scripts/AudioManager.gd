extends Node

# Esse é um sistema simples de gerenciamento de audio, a função dele é 
# organizar os arquivos e tocar o som pedido no momento em que for pedido
#
# Para tocar um audio é necessario:
# 1 - Carregar os arquivos
# 2 - Criar um AudioStreamPlayer para reproduzir o som
# 3 - No _ready, adicionar o AudioStreamPlayer a arvore de nodos
# 4 - Atribuir o arquivo de audio ao AudioStreamPlayer
# 5 - Configurar em que bus vai qual audio
#
# Funções
#
# PARA TOCAR UMA MUSICA DE FUNDO:
# Para tocar uma música de fundo é necessario chamar a função PlayBGMusic com uma string com nome
# da musica, ela parará qualquer outra música de fundo que esteja tocando e tocará a 
# música pedida.
#
# PARA TOCAR UM EFEITO SONORO:
# Para tocar um efeito sonoro é preciso chamar a função PlaySFX com o nome do efeito e ele rocará
# o efeito pedido.
#
# É necessario adicionar os "nomes" dos arquivos no match das funções PlayBGMusic e PlaySFX 
# para que ele toque corretamente.
#
# AJUSTAR VOLUME:
# Há uma função para ajustar o volume, mas no momento ela está com o trabalho em progresso
# e vai ser melhorada no futuro, mas já é um bom começo.
#
# PARA, PARA, PARA:
# Há uma função para parar todos os sons, a função StopAll.

# 1 - Carregar os arquivos
var mainMenuAudio = preload("res://Audio/Track1_MainMenu.wav")
var gameplayLoopAudio = preload("res://Audio/Track2_Gameplay.wav")
var victoryAudio = preload("res://Audio/Track4_Victory.wav")
var defeatedAudio = preload("res://Audio/Track3_Defeated.wav")
var ballHitSFX = preload("res://Audio/SFX1_BallHit.wav")
var youLoseSFX = preload("res://Audio/SFX2_YouLose.wav")

# 2 - Criar um AudioStreamPlayer para reproduzir o som
@onready var mainMenuPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var gameplayLoopPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var defeatedPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var SFXPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var victoryPlayer: AudioStreamPlayer = AudioStreamPlayer.new()

# Function to initialize the AudioManager
func _ready() -> void:
	# 3 - No _ready, adicionar o AudioStreamPlayer a arvore de nodos
	add_child(mainMenuPlayer)
	add_child(gameplayLoopPlayer)
	add_child(defeatedPlayer)
	add_child(SFXPlayer)
	add_child(victoryPlayer)
	
	# 4 - Atribuir o arquivo de audio ao AudioStreamPlayer
	mainMenuPlayer.stream = mainMenuAudio
	gameplayLoopPlayer.stream = gameplayLoopAudio
	defeatedPlayer.stream = defeatedAudio
	victoryPlayer.stream = victoryAudio

	# 5 - Configurar em que bus vai qual audio
	SetBus(mainMenuPlayer, "BGMusic")
	SetBus(gameplayLoopPlayer, "BGMusic")
	SetBus(defeatedPlayer, "Defeated")
	SetBus(SFXPlayer, "SFX")
	SetBus(victoryPlayer, "Defeated")

# Function to play the intro
func PlayBGMusic(songName: String):
	StopAll()
	match songName:
		"MainMenu":
			mainMenuPlayer.play()
		"Gameplay":
			gameplayLoopPlayer.play()
		"Defeated":
			defeatedPlayer.play()
		"Victory":
			victoryPlayer.play()

func PlaySFX(sfxName: String) -> void:
	match sfxName:
		"ballHitSFX":
			SFXPlayer.stream = ballHitSFX
			SFXPlayer.volume_db = -6.0
			SFXPlayer.play()
		"youLoseSFX":
			SFXPlayer.stream = youLoseSFX
			SFXPlayer.volume_db = 0.0
			SFXPlayer.play()

# Function to stop all audio
func StopAll():
	mainMenuPlayer.stop()
	gameplayLoopPlayer.stop()
	defeatedPlayer.stop()
	victoryPlayer.stop()

# Function to set the volume of all
# WIP: This function will split to cover the volume of each one.
func SetVolume(volume: float):
	mainMenuPlayer.volume_db = volume
	gameplayLoopPlayer.volume_db = volume
	defeatedPlayer.volume_db = volume

# Function to configure the bus of an AudioStreamPlayer
func SetBus(player: AudioStreamPlayer, busName: String):
	player.bus = busName
