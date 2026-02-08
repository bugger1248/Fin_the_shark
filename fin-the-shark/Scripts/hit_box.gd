extends Area2D
class_name HitBox

var damage : int

func disable_collision() :
	monitorable = false
	for shape in get_children():
		shape.set_deferred("disabled", true)

func enable_collision() :
	monitorable = true
	for shape in get_children():
		shape.set_deferred("disabled", false)
