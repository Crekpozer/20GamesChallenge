extends CanvasLayer

var colorTimer : float = 5000.0
var colorSpeed : float = 1.0
var rotationSpeed : float = 5 # em graus por segundo


func _process(delta):
	# Alteração de cores no fundo
	colorTimer += delta * colorSpeed
	var newColor = Color(
		abs(sin(colorTimer)),
		abs(cos(colorTimer)),
		abs(sin(colorTimer * 0.5))
	)
	%BackgroundPanel.modulate = newColor
	
	# Rotação do fundo
	%BackgroundPanel.rotation_degrees += rotationSpeed * delta
