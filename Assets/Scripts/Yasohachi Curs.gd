extends KinematicBody2D

var is_moving_left = true

#var gravity = 10
var velocity = Vector2(0, 0)

const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1

var speed = 32

var attacking = false

var projectile = preload("res://Enemies/ProjectileYasohachi.tscn")

var health : int = 75

var direction = Vector2(DIRECTION_RIGHT, 1)

var player_detect = false

func _ready():
	curr_anim("idle")

func _process(delta):
	if player_detect == true:
		move_character()

func move_character():
	velocity.x = -speed if is_moving_left else speed
	#velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func fire_projectile():
	var project = projectile.instance()
	project.rotation_degrees = rotation_degrees
	project.transform = $Muzzle.global_transform 
	project.apply_impulse(Vector2(), Vector2(800, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", project)

func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		player_detect = true
		if body.position < position:
			curr_anim("attack")
			set_direction(DIRECTION_LEFT)
		else:
			curr_anim("attack")
			set_direction(DIRECTION_RIGHT)

func _on_PlayerDetector_body_exited(body):
	if body.name == "Player":
		curr_anim("walk")
		player_detect = false

func set_direction(hor_direction):
	if hor_direction == 0:
		hor_direction = DIRECTION_RIGHT
	var hor_dir_mod = hor_direction / abs(hor_direction)
	apply_scale(Vector2(hor_dir_mod * direction.x, 1))
	direction = Vector2(hor_dir_mod, direction.y)

func curr_anim(anim):
	$AnimatedSprite.play(anim)
	
	if anim == "attack":
		attacking = true
	else:
		attacking = false

func _on_AnimatedSprite_animation_finished():
	if attacking == true:
		fire_projectile()

func hit(value_health):
	health -= value_health
	if (health <= 0):
		curr_anim("die")
		yield(get_tree().create_timer(0.8), "timeout")
		queue_free()
	else:
		$AnimatedSprite.play("hurt")


