extends CanvasLayer

var game_paused : bool = false


func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("pause"):
		if game_paused:
			unpause()
		else:
			pause()
	

func pause():
	visible = true
	get_tree().paused = true
	game_paused = true


func unpause():
	visible = false
	get_tree().paused = false
	game_paused = false
