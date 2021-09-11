extends RigidBody2D

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		queue_free()
	elif "Ground" in body.name:
		queue_free()
