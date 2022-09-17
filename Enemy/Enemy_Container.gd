extends Node2D

onready var Enemy = load("res://Enemy/Enemy.tscn")
onready var Enemy2 = load("res://Enemy/Enemy_2.tscn")

func _physics_process(_delta):
	if get_child_count() == 0:
		var enemy = Enemy.instance()
		var enemy2 = Enemy2.instance()
		add_child(enemy)
		add_child(enemy2)
