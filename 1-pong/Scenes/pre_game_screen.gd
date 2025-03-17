extends CanvasLayer

var animPlayer : AnimationPlayer

func _ready() -> void:
	animPlayer = %PreGameAnimationPlayer
	animPlayer.play("WAINTINGTOSTART")

func _process(delta: float) -> void:
	if Input:
		animPlayer.play("STARTGAME")
