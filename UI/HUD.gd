extends Control

var lives_pos = Vector2.ZERO
var lives_index = 40
onready var Indicator = load("res://UI/Indicator.tscn")

func _ready():
	lives_pos.x = 20
	lives_pos.y = Global.VP.y - 790
	update_score()
	update_time()
	update_lives()
	update_hp()

func update_score():
	$Score.text = "Score: " + str(Global.score)

func update_time():
	$Time.text = "Time: " + str(Global.time)

func update_hp():
	$HP.text = "Health: " + str(Global.health)
	
func update_lives():
	for child in $Indicator_Container.get_children():
		child.queue_free()
	for i in range(Global.lives):
		var indicator = Indicator.instance()
		indicator.position = lives_pos + Vector2(lives_index*i, 0)
		$Indicator_Container.add_child(indicator)

func _on_Timer_timeout():
	Global.time -= 1
	update_time()
	if Global.time <= 0:
		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
