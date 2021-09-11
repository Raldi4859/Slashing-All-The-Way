extends CanvasLayer

onready var health_bar = $Health

func _ready():
	Global.connect("health_changed", self, "set_health")
	health_bar.max_value = Global.max_health
	set_health()

func _process(delta):
	if Global.player_health <= 0:
		$"YourDead".show()
		get_tree().paused = true
		
func set_health():
	health_bar.value = Global.player_health


