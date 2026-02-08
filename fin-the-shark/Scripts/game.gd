extends Node2D

var time : int = 3
var fin = preload("res://Scenes/fin.tscn").instantiate()

func _ready() -> void:
	
	var actions_menu = $CanvasLayer/ActionMenu
	fin.initialize()
	add_child(fin)
	$Krabby.health_label = $Label
	
	actions_menu.connect("queue_action",fin._on_action_chosen)
	$Krabby.connect("boss_died",_on_boss_died)
	
	$Fin.health_changed.connect($CanvasLayer/HealthContainer._on_health_changed)
	actions_menu.initialize_info(fin.send_info())
	
	$Timer.start()
	
func change_label_text() -> void:
	time -= 1
	if time == 0:
		$Label2.queue_free()
		exit_standby()
		$Timer.stop()
		return
	$Label2.text = str(time)

func exit_standby():
	$Krabby.exit_standby()
	fin.exit_standby()

func _on_boss_died():
	$CanvasLayer/Panel.visible = true
	get_tree().paused = true
