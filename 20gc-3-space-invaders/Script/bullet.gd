class_name Bullet
extends Area2D

var bulletSpeed : float = 200

func _physics_process(delta: float) -> void:
	
	position.y -= bulletSpeed * delta

# Sistema de detecção de colisão da bala
# Nesse sistema a bala deve detectar comquem ela está se chocando, se ela
# estiver se chocando contra um inimigo ou projetil inimigo, ela deve se destruir
# e destuir a outra coisa.
#
# Inimigos
# - StaticBody2D
# - Classe Enemy
#
# Tiros dos Inimigos
# - Area2D
# - Classe EnemyBullet

# Signal que é recebido quando um inimigo colide com a bala
func _on_body_entered(body: Node2D) -> void:
	# Se o que bateu com a bala for um inimigo ou o tiro do inimigo
	if body is Enemy:
		print("Inimigo atingido ", body)
		body.Death() # Chama a função
		queue_free() # Se remove da cena


func _on_area_entered(area: Area2D) -> void:
	if area is EnemyBullet:
		print("Tiro do inimigo atingido: ", area)
		area.queue_free()
		queue_free()
