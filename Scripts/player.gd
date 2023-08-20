extends Area2D


const FLAP = -350
const MAX_SPEED = 400 
const ROTATION_SPEED = 2

var bird_animations = ["bird_blue", "bird_orange", "bird_red"]
var gravity_off = true
var velocity = Vector2.AXIS_Y


func jump():
	gravity_off = false
	velocity = FLAP
	rotation = deg_to_rad(-30)
	$Flap.play()


func _physics_process(delta):
	if gravity_off:
		return
		
	velocity += gravity * delta

	if velocity > MAX_SPEED:
		velocity = MAX_SPEED

	if velocity > 0 && rad_to_deg(rotation) < 90:
		rotation += ROTATION_SPEED * deg_to_rad(1)
	elif velocity < 0 && rad_to_deg(rotation) > -30:
		rotation -= ROTATION_SPEED * deg_to_rad(1)

	position.y += velocity * delta
	

func start(pos, change_skin=true):
	if change_skin:
		$AnimatedSprite2D.play(bird_animations.pick_random())
	position = pos
	rotation = 0
