extends CharacterBody3D

var move_speed := Vector3.ZERO
var max_speed : float = 100
var sprint_speed : float = 2.0

var tornado_colliding : bool = false	
var boosting : bool = false

var current_tornado_particles : float = 0
var max_tornado_particles : float = 1

func _physics_process(_delta):
	var direction = Input.get_vector("move_left","move_right", "move_down", "move_up")
	if Input.is_action_pressed("sprint"):
		boosting = true
	else:
		boosting = false
	
	if move_speed.length() > 0:
		move_speed *= 0.95
	
	if direction != Vector2.ZERO:
		move_speed += Vector3(direction.x,0,-direction.y)*(1.5 + (sprint_speed * int(boosting)))
		move_speed = move_speed.limit_length(max_speed)
	elif direction == Vector2.ZERO and move_speed.length() > 0:
		if move_speed.length() < 0.1:
			move_speed = Vector3.ZERO

	velocity = move_speed
	velocity.y = -15
	move_and_slide()
	
	if is_on_floor() or is_on_wall():
		tornado_colliding = true
	else:
		tornado_colliding = false

func _process(_delta):
	tornado_particles(tornado_colliding)
	

func tornado_particles(is_emitting : bool = false):
	if is_emitting:
		current_tornado_particles += 0.02
		current_tornado_particles = clamp(current_tornado_particles, 0, max_tornado_particles)
		%DirtParticles.amount_ratio = current_tornado_particles
		%DirtParticles.emitting = true
		
	else:
		current_tornado_particles = 0
		%DirtParticles.emitting = false
