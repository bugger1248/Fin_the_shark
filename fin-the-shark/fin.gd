extends CharacterBody2D

@export var acceleration : int = 10
@export var friction : int = 10

@export var max_speed : int = 100

@export var dash_speed : float = 5

enum CONTROL_STATE {CAN_MOVE, CANNOT_MOVE}
var current_control_state : int = CONTROL_STATE.CAN_MOVE

var direction_x : int = 0
var direction_y : int = 0

var dash_final_pos : int = 320

var is_performing : bool = false

func _process(delta: float) -> void:


	direction_x = 0
	direction_y = 0
	
	if current_control_state == CONTROL_STATE.CAN_MOVE:
		handle_movement(delta)


	position += velocity * delta

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
	
func execute_dash() -> void:
	
	current_control_state = CONTROL_STATE.CANNOT_MOVE
	
	
	
	var dash_velocity :int = 200
	velocity = Vector2(dash_velocity,0)
	
	var dash_tween : Tween = create_tween()
	var original_pos : Vector2 = position
	var final_pos : Vector2 = Vector2(dash_final_pos, position.y)
	
	dash_tween.tween_property(self, "position", final_pos, 1 / dash_speed)
	dash_tween.tween_property(self, "position", original_pos, 1 / dash_speed)

func handle_movement(delta : float) -> void:
	
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
