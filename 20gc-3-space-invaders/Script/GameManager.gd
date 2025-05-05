extends Node

var playerScore : int
var playerLives : int

func _ready() -> void:
	playerScore = 0
	playerLives = 5

func AddScore(amount) -> void:
	playerScore += amount

func DecreaseLives(amount) -> void:
	playerLives -= amount
