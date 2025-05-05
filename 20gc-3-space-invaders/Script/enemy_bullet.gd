class_name EnemyBullet
extends Area2D

# Velocidade da bala
var bulletSpeed : float = 360

func _ready() -> void:
	%RemoveTimer.start()

# Função chamada a todo frame
func _process(delta: float) -> void:
	# Atualiza a posição da bala
	position.y += bulletSpeed * delta

func Destroy() -> void:
	%CPUParticles2D.emitting = true
	queue_free() # Se remove da cena

func _on_body_entered(body: Node2D) -> void:
	# Se o que bateu com a bala for o jogador
	if body is Player:
		print("Jogador atingido")
		body.Damage() # Faz dano ao jogadors
		queue_free() # Se remove da cena


func _on_remove_timer_timeout() -> void:
	queue_free() # Se remove da cena
