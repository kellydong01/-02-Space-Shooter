extends Control


func _ready():
	pass

func _on_Restart_pressed():
	Global.reset()
	var _scene = get_tree().change_scene("res://Game.tscn")

func _on_Quit_pressed():
	var _scene = get_tree().change_scene("res://UI/Main_Menu.tscn")
