extends Node

# Onready references to AudioStreamPlayers
@onready var mainMenuPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var gameplayLoopPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var defeatedPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var SFXPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var victoryPlayer: AudioStreamPlayer = AudioStreamPlayer.new()

# Load the audio files
var mainMenuAudio = preload("res://Audio/Track1_MainMenu.wav")
var gameplayLoopAudio = preload("res://Audio/Track2_Gameplay.wav")
var victoryAudio = preload("res://Audio/Track4_Victory.wav")
var defeatedAudio = preload("res://Audio/Track3_Defeated.wav")
var ballHitSFX = preload("res://Audio/SFX1_BallHit.wav")
var youLoseSFX = preload("res://Audio/SFX2_YouLose.wav")


# Actual state of the song
var isLooping = false

# Function to initialize the AudioManager
func _ready() -> void:
	# Add AudioStreamPlayers to the tree
	add_child(mainMenuPlayer)
	add_child(gameplayLoopPlayer)
	add_child(defeatedPlayer)
	add_child(SFXPlayer)
	add_child(victoryPlayer)

	# Initialize the audio streams
	mainMenuPlayer.stream = mainMenuAudio
	gameplayLoopPlayer.stream = gameplayLoopAudio
	defeatedPlayer.stream = defeatedAudio
	victoryPlayer.stream = victoryAudio

	# Configure where each player goes in audio bus
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
