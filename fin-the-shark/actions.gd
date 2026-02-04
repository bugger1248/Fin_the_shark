extends Resource
class_name Actions

@export var name : String
@export var cooldown : float

var timer : Timer

func start_cooldown():
	if timer:
		timer.start()
		print("timer started with waitime: ",timer.time_left)
	
