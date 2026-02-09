extends Node2D

var animation_player : AnimationPlayer
var health : int = 100
var health_label : Label

var attack_interval : float = 5.0
var attack_timer : Timer = Timer.new()

enum STATES {IDLE, ATTACK, STANDBY}
var state : STATES = STATES.STANDBY

var current_attack = "wave"

var attack_array 

var shell_scene := preload("res://Scenes/shell.tscn")

var wave_counter : int = 0

@onready var timer := $Timer
@onready var sprite := $Sprite2D

signal boss_died

func _ready() -> void:
	var hurt_box :HurtBox = $HurtBox
	animation_player = $AnimationPlayer
	
	hurt_box.connect("area_entered", _on_area_entered)
	attack_timer.one_shot = true
	attack_timer.wait_time = attack_interval
	attack_timer.timeout.connect(_on_attack_timerout)
	add_child(attack_timer)
	
	timer.timeout.connect(_on_attack_timer_timeout)
	timer.one_shot = true

func exit_standby() -> void:
	attack_timer.start()
	state = STATES.IDLE

func _on_area_entered(area:Area2D):
	
	apply_damage(area.damage)

func _on_attack_timerout():
	if state == STATES.ATTACK:
		execute_attack()
		sprite.play("default")
	else:
		state = STATES.ATTACK
		sprite.play("telegraph")
		attack_timer.start()
	

func apply_damage(damage : int):
	
	animation_player.play("damage_taken")
	health -= damage
	health_label.text = str(health)
	if health <= 0:
		boss_died.emit()

func execute_attack():
	#spawn shell
	
	spawn_wave()
	timer.start(1)

func _on_attack_timer_timeout():
	if current_attack == "wave":
		spawn_wave()
		wave_counter += 1
	
	if wave_counter < 10:
		
		timer.start(1)
	else:
		attack_timer.start()
		wave_counter = 0
		state = STATES.IDLE

func spawn_wave():
	var empty_place : int = randi_range(0, 3)
	var shells : Array = []
	
	for i in range(4):
		if i == empty_place:
			continue
		
		var shell = shell_scene.instantiate()
		shell.position = Vector2(530, 40 + 100*i)
		shells.append(shell)
	
	for scene in shells:
		add_child(scene)
