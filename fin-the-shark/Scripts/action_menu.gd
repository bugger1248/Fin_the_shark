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
	
	for action in actions_array:
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = action.cooldown
		timer.one_shot = true
		timers_array.append(timer)
		action.timer = timer
		
	
	display_chosen_action()

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("action_down"):
		move_front(MENU_DIRS.DOWN)
	elif Input.is_action_just_pressed("action_up"):
		move_front(MENU_DIRS.UP)
	
	if Input.is_action_just_pressed("choose_action"):
		choose_action()
	
	
	display_available_action()

func display_chosen_action():
	var container_size : int = fin_actions_container.get_children().size()
	for i in range(container_size):
		if i == current_action:
			fin_actions_container.get_child(i).set("theme_override_colors/font_shadow_color",Color.BLACK)
		else:
			fin_actions_container.get_child(i).set("theme_override_colors/font_shadow_color",Color.TRANSPARENT)

func display_available_action():
	var container_size : int = fin_actions_container.get_child_count()
	for i in range(container_size):
		if timers_array[i].is_stopped():
			fin_actions_container.get_child(i).set("theme_override_colors/font_color", Color.WHITE)
		else:
			fin_actions_container.get_child(i).set("theme_override_colors/font_color", Color.RED)
			

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
	
	
	var chosen_action: String = actions_array[current_action].name
	
	if !actions_array[current_action].timer.is_stopped():
		return
	

	
	queue_action.emit(chosen_action)
	
