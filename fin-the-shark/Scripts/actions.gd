extends Resource
class_name Actions

@export var name : String
@export var cooldown : float

var timer : Timer

func start_cooldown():
	if timer:
		timer.start()
	
func initialize_action():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = cooldown
