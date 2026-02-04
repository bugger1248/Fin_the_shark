extends Control

const VS_KRABBY := preload("res://game.tscn")

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(VS_KRABBY)

func _on_quit_button_pressed():
	get_tree().quit()
