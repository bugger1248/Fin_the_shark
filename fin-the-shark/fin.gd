extends CharacterBody2D

@export var acceleration : int = 10
@export var friction : int = 10

@export var max_speed : int = 100

func _process(delta: float) -> void:

	var is_moving_x : bool = false
	var is_moving_y : bool = false


	if Input.is_action_pressed("move_down"):
		velocity.y += acceleration * delta
	if Input.is_action_pressed("move_up"):
		velocity.y -= acceleration * delta
	if Input.is_action_pressed("move_left"):
		velocity.x -= acceleration * delta
	if Input.is_action_pressed("move_right"):
		velocity.x += acceleration * delta


	#

	clamp_velocity()
	
	
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

func apply_friction(on_x : bool, on_y : bool) -> void:
	velocity = velocity.move_toward(Vector2.ZERO,friction)
