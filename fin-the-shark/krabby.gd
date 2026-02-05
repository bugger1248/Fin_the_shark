extends Node2D

var animation_player : AnimationPlayer
var health : int = 100
var health_label : Label

var attack_interval : float = 3.0
var attack_timer : Timer = Timer.new()

enum STATES {IDLE, ATTACK}
var state : STATES = STATES.IDLE

var attack_array 

var shell_scene := preload("res://shell.tscn")

signal boss_died

func _ready() -> void:
	var hurt_box :HurtBox = $HurtBox
	animation_player = $AnimationPlayer
	
	hurt_box.connect("area_entered", _on_area_entered)
	attack_timer.one_shot = true
	attack_timer.wait_time = attack_interval
	attack_timer.timeout.connect(_on_attack_timerout)
	add_child(attack_timer)
	attack_timer.start()
	

func _on_area_entered(area:Area2D):
	
	apply_damage(area.damage)

func _on_attack_timerout():
	state = STATES.ATTACK
	execute_attack()
	

func apply_damage(damage : int):
	
	animation_player.play("damage_taken")
	health -= damage
	health_label.text = str(health)
	if health <= 0:
		boss_died.emit()

func execute_attack():
	#spawn shell
	var shell = shell_scene.instantiate()
	shell.position = Vector2(530, 310)
	add_child(shell)
	
	
	attack_timer.start()
