extends Node2D

onready var Enemy = load("res://Enemy/Enemy.tscn")
onready var Enemy2 = load("res://Enemy/Enemy_2.tscn")
onready var Enemy3 = load("res://Enemy/Enemy3.tscn")

onready var s1 = true
onready var s2 = true
onready var s3 = true
onready var s4 = true

func _physics_process(_delta):
	if get_child_count() == 0:
		var enemy = Enemy.instance()
		var enemy2 = Enemy2.instance()
		add_child(enemy)
		add_child(enemy2)
	if get_child_count() < 2:
		var enemy = Enemy.instance()
		var enemy2 = Enemy2.instance()
		add_child(enemy)
		add_child(enemy2)
	if Global.time < 110 and s1:
		var enemy3 = Enemy3.instance()
		add_child(enemy3)
		s1 = false
	if Global.time < 85 and s2:
		var enemy3 = Enemy3.instance()
		add_child(enemy3)
		s2 = false
	if Global.time < 60 and s3:
		var enemy3 = Enemy3.instance()
		add_child(enemy3)
		s3 = false
	if Global.time < 30 and s4:
		var enemy3 = Enemy3.instance()
		add_child(enemy3)
		s4 = false
