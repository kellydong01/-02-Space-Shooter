extends Node

const SCORES = "user://scores.sav"
const SECRET = "PEWPEWPEW"

var VP = Vector2.ZERO

var score = 0
var time = 0
var lives = 0
var health = 0
var bullets = 0
var highest_score = 0

var scores = []

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	randomize()
	VP = Vector2(2560, 2602)
	var _signal = get_tree().get_root().connect("size_changed", self, "_resize")
	reset()

func _resize():
	pass

func reset():
	get_tree().paused = false
	score = 0
	time = 120
	lives = 6
	health = 100
	bullets = 50
	load_scores()
	if len(scores) > 0:
		highest_score = scores[0]['score']
	else:
		highest_score = 0

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

func update_bullets():
	bullets -= 1
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if bullets < 0:
		var reload = Timer.new()
		reload.set_wait_time(2)
		reload.set_one_shot(true)
		self.add_child(reload)
		reload.start()
		yield(reload, "timeout")
		bullets = 50
		reload.queue_free()
	if hud != null:
		hud.update_bullets()

func add_score():
	var temp = []
	var trailer = 10000000
	var added = false
	for s in scores:
		if score < trailer and score > s["score"]:
			temp.append({"score": score})
			added = true
		temp.append(s)
		trailer = s["score"]
	if not added:
		temp.append({"score": score})
	scores = temp
	save_scores()

func load_scores():
	var save_scores = File.new() 
	if not save_scores.file_exists(SCORES):
		return
	
	save_scores.open_encrypted_with_pass(SCORES, File.READ, SECRET)
	var contents = save_scores.get_as_text()
	var json_contents = JSON.parse(contents)
	if json_contents.error == OK:
		scores = json_contents.result
	save_scores.close()

func save_scores():
	var save_scores = File.new()
	save_scores.open_encrypted_with_pass(SCORES, File.WRITE, SECRET)
	save_scores.store_string(to_json(scores))
	
