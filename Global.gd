extends Node

var VP = Vector2.ZERO

var score = 0
var time = 0
var lives = 0
var health = 0

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	randomize()
	VP = get_viewport().size
	var _signal = get_tree().get_root().connect("size_changed", self, "_resize")
	reset()
	

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		var Menu = get_node_or_null("/root/Game/UI/Menu")
		if Menu == null:
			get_tree().quit()
		else:
			if Menu.visible:
				get_tree().paused = false
				Menu.hide()
			else:
				get_tree().paused = true
				Menu.show()

func _resize():
	VP = get_viewport().size

func reset():
	get_tree().paused = false
	score = 0
	time = 90
	lives = 5
	health = 80

func update_hp(h):
	health -= h
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_hp()

func update_score(s):
	score += s
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_score()
		
func update_lives():
	lives -= 1
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if lives == 0:
		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
	if hud != null:
		hud.update_lives()
