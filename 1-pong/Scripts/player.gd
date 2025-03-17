extends StaticBody2D

var windowHeight : float # Altura da janela
var paddleHeight : float # Altura da barra

var hasPressedAction : bool = false
var isTipsOn : bool = true

var gameHasStarted : bool = false

func _ready():
	windowHeight = get_viewport_rect().size.y
	paddleHeight = %Sprite2D.global_position.y

func _process(delta: float) -> void:
	
	if gameHasStarted:
		if Input.is_action_pressed("up1"): # Apertar para cima
			hasPressedAction = true
			position.y -= get_parent().paddleSpeed * delta
		elif Input.is_action_pressed("down1"): # Apertar para baixo
			hasPressedAction = true
			position.y += get_parent().paddleSpeed * delta
		
		# Limitar a barra na janela
		position.y = clamp(position.y, paddleHeight / 2 - 75, windowHeight - paddleHeight / 2 + 75)
		
		if hasPressedAction && isTipsOn:
			print("desligando dicas")
			isTipsOn = false
			%TipsAnimationPlayer.play("TIPSANIMATION")

func TurnOnControllers() -> void:
	gameHasStarted = true
