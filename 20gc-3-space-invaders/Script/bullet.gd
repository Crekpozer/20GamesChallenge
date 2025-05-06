class_name Bullet
extends Area2D

# Signal disparado quando a bala é destruida
signal bulletDestroyed

# Velocidade do projetil
var bulletSpeed : float = 400 

# Função que processa a fisica
func _physics_process(delta: float) -> void:
	
	# Move a bala no eixo y negativamente
	position.y -= bulletSpeed * delta

# Signal que é recebido quando um inimigo colide com a bala
func _on_body_entered(body: Node2D) -> void:
	# Se o que bateu com a bala for um inimigo
	if body is Enemy:
		body.Death() # Chama a função
		queue_free() # Se remove da cena
		get_parent().enemiesKilled += 1 # Informa ao sistema de estatistica que o tiro acertou o inimigo

# Signal que é recebido quando uma bala encosta na outra
func _on_area_entered(area: Area2D) -> void:
	if area is EnemyBullet: # Se o que bateu com a bala for o tiro do inimigo
		emit_signal("bulletDestroyed") # Emite um sinal que uma bala foi destruida
		area.Destroy() # Chama a função na bala que a destroi
		queue_free() # Limpa da memoria
