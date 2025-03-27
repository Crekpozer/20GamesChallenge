extends CanvasLayer

# Signal emitted when hte loading screen completely covers the screen
signal loading_screen_has_full_coverage

# Reference to the AnimationPlayer
@onready var animationPlayer: AnimationPlayer = %AnimationPlayer
# Reference to the ProgressBar
@onready var progressBar: ProgressBar = %ProgressBar

func _ready() -> void:
	%Ball.NewBall()
	%Ball2.NewBall()
	%Ball3.NewBall()
	%Ball4.NewBall()
	%Ball5.NewBall()
	%Ball6.NewBall()
	%Ball7.NewBall()
	%Ball8.NewBall()
	%Ball9.NewBall()
	%Ball10.NewBall()

# Function to update the progress bar value
# newValue: the nre progress value (between 0 and 1)
func UpdateProgressBar(newValue: float) -> void:
	# Update the progress bar without emitting the signal
	progressBar.set_value_no_signal(newValue * 100)

# Function to start the outro animation and remove the loading screen
func StartOutroAnimation() -> void:
	# Await the completion of the current animation
	await Signal(animationPlayer, "animation_finished")
	# Play the outro animation
	animationPlayer.play("end_load")
	# Await the completion of the outro animation
	await Signal(animationPlayer, "animation_finished")
	# Remove the loading screen from the scene tree
	self.queue_free()
