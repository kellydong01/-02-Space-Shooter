extends Control

func _ready():
	Global.add_score()
	$Label.text = "Thanks for playing! Your final score was " + str(Global.score) + "."
	$"High Scores".text = "High Scores:\n"
	var count = 0
	for score in Global.scores:
		if count < 8:
			$"High Scores".text +=  str(score["score"]) + "\n"
			count += 1
		

func _on_Quit_pressed():
	get_tree().quit()

func _on_Play_Again_pressed():
	Global.reset()
	var _scene = get_tree().change_scene("res://Game.tscn")
