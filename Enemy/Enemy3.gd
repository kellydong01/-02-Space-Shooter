extends KinematicBody2D

var y_positions = [400, 1500, 2300]
var x_positions = [-100, 1800, 2200]
var initial_position = Vector2.ZERO
var direction = Vector2(1.5,0)
var wobble = 40
var r_speed = 4.0

var nose = Vector2(0, -60)
var health = 24

var Effects = null
onready var Explosion = load("res://Effects/Explosion.tscn")
onready var Enemy_Bullet = load("res://Enemy/Enemy_Bullet_2.tscn")

func _ready():
	initial_position.x = x_positions[randi() % x_positions.size()]
	initial_position.y = y_positions[randi() % y_positions.size()]
	position = initial_position
	
func _physics_process(_delta):
	rotation_degrees += r_speed
	position += direction*3.5
	position.y = initial_position.y + sin(position.x/20)*wobble
	position.x = wrapf(position.x, 0, Global.VP.x)
	position.y = wrapf(position.y, 0, Global.VP.y)

func damage(d):
	health -= d
	if health <= 0:
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			explosion.global_position = global_position
			Effects.add_child(explosion)
			Global.update_score(1000)
		queue_free()

func _on_Timer_timeout():
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	Effects = get_node_or_null("/root/Game/Effects")
	if Player != null and Effects != null:
		var dir = [PI/2, PI/4, 0, 7*PI/4, 3*PI/2, 5*PI/4, PI, 3*PI/4]
		for d in dir:
			var bullet = Enemy_Bullet.instance()
			bullet.global_position = global_position + nose.rotated(d)
			bullet.rotation = d
			Effects.add_child(bullet)


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.damage(100)
		damage(100)

