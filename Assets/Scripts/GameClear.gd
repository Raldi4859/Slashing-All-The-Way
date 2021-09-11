extends Control

func _ready():
	$VBoxContainer/BackButton.grab_focus()


func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
