extends Node2D


func _ready() -> void:
	var actions_menu = $CanvasLayer/ActionMenu
	var fin = $Fin
	$Krabby.health_label = $Label
	
	actions_menu.connect("queue_action",fin._on_action_chosen)
	$Krabby.connect("boss_died",_on_boss_died)

func _on_boss_died():
	$CanvasLayer/Panel.visible = true
	get_tree().paused = true
