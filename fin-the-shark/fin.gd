extends CharacterBody2D

@export var acceleration : int = 10
@export var friction : int = 10

@export var max_speed : int = 100

var direction_x : int = 0
var direction_y : int = 0

func _process(delta: float) -> void:


	direction_x = 0
	direction_y = 0

	if Input.is_action_pressed("move_down"):
		direction_y = 1
	if Input.is_action_pressed("move_up"):
		direction_y = -1
	

	if Input.is_action_pressed("move_left"):
		direction_x = -1
	if Input.is_action_pressed("move_right"):
		direction_x = 1


	velocity.x += direction_x * acceleration * delta
	velocity.y += direction_y * acceleration * delta

	clamp_velocity()
	
	
	apply_friction()
	position += velocity * delta
	print(velocity)

func clamp_velocity() -> void:
	if velocity.x > max_speed:
		velocity.x = max_speed
	elif velocity.x < max_speed * (-1):
		velocity.x = max_speed * (-1)
	
	if velocity.y > max_speed:
		velocity.y = max_speed
	elif velocity.y < max_speed * (-1):
		velocity.y = max_speed * (-1)

func apply_friction() -> void:
	
	
	
	if direction_x == 0:
		
		if abs(velocity.x) < friction:
			velocity.x = 0
		
		if velocity.x > 0:
			velocity.x -= friction
		elif velocity.x < 0:
			velocity.x += friction
	
	if direction_y == 0:
		
		if abs(velocity.y) < friction:
			velocity.y = 0
		
		if velocity.y > 0:
			velocity.y -= friction
		elif velocity.y < 0:
			velocity.y += friction
	
