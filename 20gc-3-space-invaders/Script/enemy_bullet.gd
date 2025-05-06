class_name EnemyBullet
extends Area2D

# Velocidade da bala
var bulletSpeed : float = 360

# Função tocada quando incia o script
func _ready() -> void:
	%RemoveTimer.start() # Inicia o timer para apagar a bala

# Função chamada a todo frame
func _process(delta: float) -> void:
	# Atualiza a posição da bala
	position.y += bulletSpeed * delta

# Função que toca para destruir a bala
func Destroy() -> void:
	%CPUParticles2D.emitting = true # Dispara as particulas
	queue_free() # Se remove da cena

# Função que dispara quando a bala bate na bala
func _on_body_entered(body: Node2D) -> void:
	# Se o que bateu com a bala for o jogador
	if body is Player:
		print("Jogador atingido")
		body.Damage() # Faz dano ao jogadors
		queue_free() # Se remove da cena


func _on_remove_timer_timeout() -> void:
	queue_free() # Se remove da cena
