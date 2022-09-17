extends KinematicBody2D

var y_positions = [100,150,200,500,550]
var x_positions = [-100, 800]
var initial_position = Vector2.ZERO
var direction = Vector2(1.5,0)
var wobble = 25.0

var nose = Vector2(0, -60)
var health = 15

var Effects = null
onready var Explosion = load("res://Effects/Explosion.tscn")
onready var Enemy_Bullet = load("res://Enemy/Enemy_Bullet_1.tscn")

func _ready():
	initial_position.x = x_positions[randi() % x_positions.size()]
	initial_position.y = y_positions[randi() % y_positions.size()]
	position = initial_position
	
func _physics_process(_delta):
	position += direction*2
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
			Global.update_score(250)
		queue_free()

func _on_Timer_timeout():
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	Effects = get_node_or_null("/root/Game/Effects")
	if Player != null and Effects != null:
		var dir = global_position.angle_to_point(Player.global_position) - PI/2
		var enemy_bullet = Enemy_Bullet.instance()
		enemy_bullet.global_position = global_position + nose.rotated(dir)
		enemy_bullet.rotation = dir
		Effects.add_child(enemy_bullet)


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.damage(100)
		damage(100)
