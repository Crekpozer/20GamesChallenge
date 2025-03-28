extends StaticBody2D

var windowWidth : float # Altura da janela
var paddleWidth : float # Altura da barra

var ballRef : CharacterBody2D
var ballLaunched : bool = false

# var hasPressedAction : bool = false
# var isTipsOn : bool = true

var isGameOver : bool = false

var paddleSpeed : int = 500

func _ready():
	windowWidth = get_viewport_rect().size.x
	paddleWidth = %ColorRect.size.x
	ballRef = %Ball

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("left1"): # Apertar para cima
		# hasPressedAction = true
		position.x -= paddleSpeed * delta
	elif Input.is_action_pressed("right1"): # Apertar para baixo
		# hasPressedAction = true
		position.x += paddleSpeed * delta
	
	# Limitar a barra na janela
	position.x = clamp(position.x, paddleWidth / 2 + 10, windowWidth - paddleWidth / 2 - 10)

func _input(event: InputEvent) -> void:
	var input = event.as_text()
	match input:
		"Space":
			if not ballLaunched:
				ballLaunched = true
				%BallSprite2D.visible = false
				ballRef.NewBall(%BallSprite2D.global_position)
				ballRef.visible = true

# func _on_up_touch_screen_button_pressed() -> void:
# 	pass # Replace with function body.

# func _on_down_touch_screen_button_pressed() -> void:
# 	pass # Replace with function body.

func _on_ball_pass_through_body_entered(body: Node2D) -> void:
	# Verificar se o jogador tem vidas restantes
	# Se tiver:
	# - Diminuiu uma vida do jogador
	# - Mostrar a bola da barra
	# - Marcar a bola como não lançada
	# Se não tiver:
	# - Mostrar tela de game over
	pass # Replace with function body.
