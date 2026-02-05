extends HitBox

@export var velocity : int

func _process(delta: float) -> void:
	position.x -= velocity * delta



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
