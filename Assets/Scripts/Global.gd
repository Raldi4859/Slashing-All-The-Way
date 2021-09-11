extends Node

var max_health: int = 500
var player_health: int = max_health

signal health_changed(new_value)
signal new_scene_health(new_value)

func reset():
	player_health = max_health
	emit_signal("health_changed")
