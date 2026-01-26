extends Node2D


func _ready() -> void:
	var actions_menu = $CanvasLayer/ActionMenu
	var fin = $Fin
	
	actions_menu.connect("queue_action",fin._on_action_chosen)
