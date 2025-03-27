extends StaticBody2D

var ballPosition: Vector2
var distance: float
var moveBy: float

var windowHeight: float
var paddleHeight: float

func _ready() -> void:
	windowHeight = get_viewport_rect().size.y
	paddleHeight = 150.0

func _process(delta: float) -> void:
	# Move a barra na direção da bola
	ballPosition = %Ball.position
	distance = position.y - ballPosition.y
	
	if abs(distance) > get_parent().paddleSpeed * delta:
		moveBy = get_parent().paddleSpeed * delta * (distance / abs(distance))
	else:
		moveBy = distance
	
	position.y -= moveBy
	position.y = clamp(position.y, paddleHeight / 2, windowHeight - paddleHeight / 2)
