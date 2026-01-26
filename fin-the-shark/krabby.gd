extends Node2D

var animation_player : AnimationPlayer

func _ready() -> void:
	var hurt_box :Area2D = $HurtBox
	animation_player = $AnimationPlayer
	
	hurt_box.connect("area_entered", _on_area_entered)

	
func _on_area_entered(_area:Area2D):
	apply_damage()

func apply_damage():
	animation_player.play("damage_taken")
