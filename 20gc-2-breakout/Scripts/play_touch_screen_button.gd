extends TouchScreenButton

var playTouchAnimationPlayer : AnimationPlayer

func _ready() -> void:
	playTouchAnimationPlayer = %PlayTouchAnimationPlayer
	playTouchAnimationPlayer.play()

func _on_pressed() -> void:
	visible = false
