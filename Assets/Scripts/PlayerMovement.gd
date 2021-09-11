extends KinematicBody2D
##Variabel yang digunakan untuk 'Player_Behaviour'
var velocity = Vector2(0,0)
var direction = Vector2(DIRECTION_RIGHT,1)
const SPEED = 200
const GRAVITY = 30
const JUMPPOWER = -900
const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1

var rageBar = 0;
var isAttacking = false;
var rageMode = false;
var died = false;

signal player_died

func _ready():
	connect("player_died", self, "update_player")
	died = false

func _physics_process(_delta):
	##Code untuk 'movement'
	##Keymap : right = arrow key right
	##		   left = arrow key left
	##         crouch = arrow key down
	##		   attack = space 
	if died == false:
		if Input.is_action_pressed("right") and isAttacking == false:
			velocity.x = SPEED
			set_direction(DIRECTION_RIGHT)
			if rageMode == false:
				$AnimatedSprite.play("run1")
			else:
				$AnimatedSprite.play("run2")
		elif Input.is_action_pressed("left") and isAttacking == false:
			velocity.x = -SPEED
			set_direction(DIRECTION_LEFT)
			if rageMode == false:
				$AnimatedSprite.play("run1")
			else:
				$AnimatedSprite.play("run2")
		else:
			velocity.x = 0;
			if rageMode == false:
				if isAttacking == false:
					$AnimatedSprite.animation = "idle1"
			else:
				if isAttacking == false:
					$AnimatedSprite.animation = "idle2"
	
		if Input.is_action_pressed("crouch") and is_on_floor() and isAttacking == false:
			$Crouch.disabled = false;
			$StandUp.disabled = true;
			$HitDetection/CollisionShape2D.disabled = true;
			if rageMode == false:
				$AnimatedSprite.play("crouch1")
			else:
				$AnimatedSprite.play("crouch2")
		else:
			if is_on_floor():
				$Crouch.disabled = true;
				$StandUp.disabled = false;
				$HitDetection/CollisionShape2D.disabled = false;
	
	##Code untuk 'attack'
		if Input.is_action_just_pressed("attack"):
			if rageMode == false:
				$AnimatedSprite.play("attack1")
				$SoundAttack.play()
				isAttacking = true;
				$AttackArea/AttackCollision.disabled = false;
			else:
				$AnimatedSprite.play("attack2")
				$SoundRageAtk.play()
				isAttacking = true;
				$AttackArea/AttackCollision.disabled = false;
			
		##Code untuk rage mode
		if rageBar >= 150:
			rageMode = true
	
		velocity.y += GRAVITY
		velocity.x = lerp(velocity.x,0,0.2)
		velocity = move_and_slide(velocity, Vector2.UP)


func set_direction(hor_direction):
	if hor_direction == 0:
		hor_direction = DIRECTION_RIGHT
	var hor_dir_mod = hor_direction / abs(hor_direction)
	apply_scale(Vector2(hor_dir_mod * direction.x, 1))
	direction = Vector2(hor_dir_mod, direction.y)
	
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack1" or $AnimatedSprite.animation == "attack2":
		$AttackArea/AttackCollision.disabled = true;
		isAttacking = false;

func _on_AttackArea_body_entered(body):
	if body.is_in_group("Enemy"):
		if body.has_method("hit"):
			if rageMode == false:
				body.hit(35)
				rageBar = rageBar + 35
			else:
				body.hit(60)

func kill():
	get_tree().reload_current_scene()

func player_hit(num):
	if Global.player_health <= 500:
		Global.player_health -= num
		Global.emit_signal("health_changed")
	elif Global.player_health <= 0:
		emit_signal("player_died")
		update_player()
		$AnimatedSprite.play("die")
		
func update_player():
	died = true
	
func _on_HitDetection_body_entered(body):
	if "ProjectileKechizu" in body.name:
		player_hit(15)

	elif "ProjectileYasohachi" in body.name:
		player_hit(10)
	


