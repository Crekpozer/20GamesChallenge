extends Node2D

var score : Array = [0,0] #0:Player 1:CPU
const paddleSpeed : int = 500
var gameIsOver : bool = false

enum GameState{PREGAME,GAME,INTERVAL,AFTERGAME}
var currentGameState : GameState


@onready var animationPlayer : AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	currentGameState = GameState.PREGAME

func _process(delta: float) -> void:
	
	if score[0] == 1:
		YouWin()
	elif score[1] == 3:
		YouLose()

func StartGame() -> void:
	pass

func _on_ball_timer_timeout() -> void:
	
	if not gameIsOver:
		%Ball.NewBall()

func _on_score_left_body_entered(body: Node2D) -> void:
	score[1] += 1
	%ScoreCPU.text = str(score[1])
	if not gameIsOver:
		%BallTimer.start()

func _on_score_right_body_entered(body: Node2D) -> void:
	score[0] += 1
	%ScorePlayer.text = str(score[0])
	if not gameIsOver:
		%BallTimer.start()

func YouWin() -> void:
	set_process(false)
	animationPlayer.play("YOUWIN")
	gameIsOver = true

func YouLose() -> void:
	set_process(false)
	animationPlayer.play("YOULOSE")
	gameIsOver = true
