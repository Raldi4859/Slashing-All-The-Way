extends Control

func _on_ReturnButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_RestartButton_pressed():
	get_tree().paused = false
	Global.reset()
	get_tree().change_scene("res://Scenes/Area1.tscn")
