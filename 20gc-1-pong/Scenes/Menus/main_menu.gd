extends CanvasLayer

func _ready() -> void:
	AudioManager.PlayBGMusic("MainMenu")

func _on_single_player_pressed() -> void:
	LoadManager.LoadScene("res://Scenes/ArenaSP.tscn")

func _on_multiplayer_pressed() -> void:
	LoadManager.LoadScene("res://Scenes/ArenaMP.tscn")
