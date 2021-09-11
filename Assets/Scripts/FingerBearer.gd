extends KinematicBody2D

var is_moving_left = true

#var gravity = 10
var velocity = Vector2(0, 0)

const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1

var speed = 32

var attacking = false

var health : int = 500

var direction = Vector2(DIRECTION_RIGHT, 1)

var player_detect = false

var player

func _ready():
	curr_anim("walk")

func _process(delta):
	if player_detect == false:
		move_character()

func move_character():
	velocity.x = -speed if is_moving_left else speed
	#velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		player_detect = true
		player = body
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

func hit(value_health):
	health -= value_health
	if (health <= 0):
		curr_anim("die")
		yield(get_tree().create_timer(0.8), "timeout")
		queue_free()

func _on_AttackDetector_body_entered(body):
	if body.has_method("player_hit"):
		body.player_hit(12)
		
func _on_AnimatedSprite_animation_finished():
	if attacking == true:
		_on_AttackDetector_body_entered(player)
