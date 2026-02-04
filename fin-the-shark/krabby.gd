extends Node2D

var animation_player : AnimationPlayer
var health : int = 100
var health_label : Label

var attack_interval : float = 5.0
var attack_timer : Timer = Timer.new()

enum STATES {IDLE, ATTACK}
var state : STATES = STATES.IDLE

var attack_array 

signal boss_died

func _ready() -> void:
	var hurt_box :HurtBox = $HurtBox
	animation_player = $AnimationPlayer
	
	hurt_box.connect("area_entered", _on_area_entered)
	attack_timer.one_shot = true
	attack_timer.wait_time = attack_interval
	add_child(attack_timer)
	attack_timer.timeout.connect(_on_attack_timerout)
	

func _on_area_entered(area:Area2D):
	
	apply_damage(area.damage)

func _on_attack_timerout():
	pass

func apply_damage(damage : int):
	
	animation_player.play("damage_taken")
	health -= damage
	health_label.text = str(health)
	if health <= 0:
		boss_died.emit()

func execute_attack():
	#spawn shell
	pass
