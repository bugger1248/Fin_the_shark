extends Control

enum MENU_DIRS {LEFT, RIGHT, UP, DOWN}

var current_action : int = 0
var actions_array : Array[Actions]
var timers_array : Array[Timer]

signal queue_action(action:String)

@onready var fin_actions_container : VBoxContainer = $HBoxContainer/FinActionsContainer

func _ready() -> void:
	
	
	actions_array = [
		preload("res://bite.tres"),
		preload("res://dash.tres")
	]
	
	for i in range(actions_array.size()):
		timers_array.append(Timer.new())
		timers_array[i].wait_time = actions_array[i].cooldown
		add_child(timers_array[i])
	
	display_chosen_action()

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("action_down"):
		move_front(MENU_DIRS.DOWN)
	elif Input.is_action_just_pressed("action_up"):
		move_front(MENU_DIRS.UP)
	
	if Input.is_action_just_pressed("choose_action"):
		choose_action()

func display_chosen_action():
	var container_size : int = fin_actions_container.get_children().size()
	for i in range(container_size):
		if i == current_action:
			fin_actions_container.get_child(i).set("theme_override_colors/font_shadow_color",Color.BLACK)
		else:
			fin_actions_container.get_child(i).set("theme_override_colors/font_shadow_color",Color.TRANSPARENT)


func move_front(dir:MENU_DIRS):
	if dir == MENU_DIRS.UP:
		if actions_array.size() <= (current_action + 1):
			current_action = 0
		else:
			current_action += 1
	
	elif dir == MENU_DIRS.DOWN:
		if current_action <= 0:
			current_action = actions_array.size() - 1
		else:
			current_action -= 1
	
	display_chosen_action()

func choose_action():
	
	var chosen_timer : Timer = timers_array[current_action]
	
	var chosen_action: String = actions_array[current_action].name
	
	if chosen_timer.time_left > 0 :
		print("action is timed out")
		return
	
	queue_action.emit(chosen_action)
	
	print("this action was chosen : ",chosen_action)
