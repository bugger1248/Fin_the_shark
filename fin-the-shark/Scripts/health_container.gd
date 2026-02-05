extends Label

var health : int

func _on_health_changed(new : int):
	health = new
	text = "HP : " + str(health)
