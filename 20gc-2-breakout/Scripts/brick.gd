class_name Brick
extends StaticBody2D

var brickAnimationPlayer : AnimationPlayer # Referencia ao animation player

func _ready() -> void:
	brickAnimationPlayer = %BrickAnimationPlayer # Atribue o animation player à variavel
	
	var animationToPlay : int = randi_range(0, 15) # Escolhe uma das animações para tocar
	
	match animationToPlay:
		0:
			# Pattern 1-1
			brickAnimationPlayer.play("Pattern 1")
			%Sparkle.position = Vector2(-29, -6)
			%Sparkle2.position = Vector2(28, 6)
		1:
			# Pattern 1-2
			brickAnimationPlayer.play("Pattern 1")
			%Sparkle.position = Vector2(-36, 11)
			%Sparkle2.position = Vector2(36, -11)
		2:
			# Pattern 1-3
			brickAnimationPlayer.play("Pattern 1")
			%Sparkle.position = Vector2(-13, 6)
			%Sparkle2.position = Vector2(-5, -7)
		3:
			# Pattern 2-1
			brickAnimationPlayer.play("Pattern 2")
			%Sparkle.position = Vector2(-29, -6)
			%Sparkle2.position = Vector2(28, 6)
		4:
			# Pattern 2-2
			brickAnimationPlayer.play("Pattern 2")
			%Sparkle.position = Vector2(-36, 11)
			%Sparkle2.position = Vector2(36, -11)
			
		5:
			# Pattern 2-3
			brickAnimationPlayer.play("Pattern 2")
			%Sparkle.position = Vector2(-13, 6)
			%Sparkle2.position = Vector2(-5, -7)
		6:
			# Pattern 3-1
			brickAnimationPlayer.play("Pattern 3")
			%Sparkle.position = Vector2(-29, -6)
			%Sparkle2.position = Vector2(28, 6)
		7:
			# Pattern 3-2
			brickAnimationPlayer.play("Pattern 3")
			%Sparkle.position = Vector2(-36, 11)
			%Sparkle2.position = Vector2(36, -11)
		8:
			# Pattern 3-3
			brickAnimationPlayer.play("Pattern 3")
			%Sparkle.position = Vector2(-13, 6)
			%Sparkle2.position = Vector2(-5, -7)
		9:
			# Pattern 4-1
			brickAnimationPlayer.play("Pattern 4")
			%Sparkle.position = Vector2(-29, -6)
			%Sparkle2.position = Vector2(28, 6)
		10:
			# Pattern 5-1
			brickAnimationPlayer.play("Pattern 5")
			%Sparkle.position = Vector2(-29, -6)
			%Sparkle2.position = Vector2(28, 6)
		11:
			# Pattern 5-2
			brickAnimationPlayer.play("Pattern 5")
			%Sparkle.position = Vector2(-36, 11)
			%Sparkle2.position = Vector2(36, -11)
		12:
			# Pattern 5-3
			brickAnimationPlayer.play("Pattern 5")
			%Sparkle.position = Vector2(-13, 6)
			%Sparkle2.position = Vector2(-5, -7)
		13:
			# Pattern 6-1
			brickAnimationPlayer.play("Pattern 6")
			%Sparkle.position = Vector2(-29, -6)
			%Sparkle2.position = Vector2(28, 6)
		14:
			# Pattern 6-2
			brickAnimationPlayer.play("Pattern 6")
			%Sparkle.position = Vector2(-36, 11)
			%Sparkle2.position = Vector2(36, -11)
		15:
			# Pattern 6-3
			brickAnimationPlayer.play("Pattern 6")
			%Sparkle.position = Vector2(-13, 6)
			%Sparkle2.position = Vector2(-5, -7)
