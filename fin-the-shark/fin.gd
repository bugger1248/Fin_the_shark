extends CharacterBody2D

@export var acceleration : int = 10
@export var friction : int = 10

@export var max_speed : int = 100

@export var dash_velocity :int = 200

enum CONTROL_STATE {CAN_MOVE, CANNOT_MOVE}
enum ACTIONS {NONE, DASH}

var actions_array :Array[Actions]

var current_action : int = ACTIONS.NONE
var current_control_state : int = CONTROL_STATE.CAN_MOVE

var direction_x : int = 0
var direction_y : int = 0

var dash_final_pos : int = 560

var is_performing : bool = false

var original_pos : Vector2

@onready var hit_box : HitBox = $HitBox
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hurt_box : HurtBox = $HurtBox

var health : int = 3

signal health_changed(new:int)

func _ready() -> void:
	actions_array = [
		preload("res://bite.tres"),
		preload("res://dash.tres")
	]
	
	hurt_box.area_entered.connect(_on_hurt_box_entered)

func _process(delta: float) -> void:
	
	
	direction_x = 0
	direction_y = 0
	
	if current_control_state == CONTROL_STATE.CAN_MOVE:
		handle_movement(delta)
	
	if current_action == ACTIONS.DASH:
		execute_dash()
	
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
	
	if current_action == ACTIONS.NONE:
		hurt_box.monitoring = false
		hit_box.damage = 20
		current_control_state = CONTROL_STATE.CANNOT_MOVE
		current_action = ACTIONS.DASH
		velocity = Vector2(dash_velocity,0)
		
		original_pos = position
		
		hit_box.monitorable = true
	
	if position.x >= dash_final_pos :
		velocity = Vector2(dash_velocity * -1, 0)
		hit_box.monitorable = false
	
	if position.x < original_pos.x :
		hurt_box.monitoring = true
		actions_array[1].start_cooldown()
		velocity = Vector2.ZERO
		current_action = ACTIONS.NONE
		current_control_state = CONTROL_STATE.CAN_MOVE


func execute_bite() -> void:
	animation_player.play("bite")
	actions_array[0].start_cooldown()

func _on_hurt_box_entered(_area : Area2D) -> void:
	health -= 1
	animation_player.play("hit")
	health_changed.emit(health)
	
	if health <= 0:
		set_process(false)

func _on_action_chosen(action: String) -> void:
	
	if current_action != ACTIONS.NONE:
		return
	
	if action == "dash":
		execute_dash()
	
	if action == "bite":
		execute_bite()

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
