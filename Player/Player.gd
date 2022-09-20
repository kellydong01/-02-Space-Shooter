extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 5.0
var max_speed = 500.0
var rot_speed = 4.0

var nose = Vector2(0, -60)

var health = Global.health

onready var Bullet = load("res://Player/Bullet.tscn")
onready var Explosion = load("res://Effects/Explosion.tscn")
var Effects = null
var Planet = null
var planet_mass = 200000.0
var planet_mass_2 = 350000.0
var black_hole_mass = 800000.0

func _ready():
	pass
	
func _physics_process(_delta):
	Planet = get_node_or_null("/root/Game/Planet")
	if Planet != null:
		var gravity = global_position.direction_to(Planet.global_position) * 1/pow(global_position.distance_to(Planet.global_position), 2) * planet_mass
		velocity += gravity
	Planet = get_node_or_null("/root/Game/Planet2")
	if Planet != null:
		var gravity = global_position.direction_to(Planet.global_position) * 1/pow(global_position.distance_to(Planet.global_position), 2) * planet_mass_2
		velocity += gravity
	var Black_Hole = get_node_or_null("/root/Game/Black_Hole")
	if Black_Hole != null:
		var gravity = global_position.direction_to(Black_Hole.global_position) * 1/pow(global_position.distance_to(Black_Hole.global_position), 2) * black_hole_mass
		velocity += gravity
	velocity += get_input()*speed
	velocity = velocity.normalized() * clamp(velocity.length(), 0, max_speed)
	velocity = move_and_slide(velocity, Vector2.ZERO)
	position.x = wrapf(position.x, 0.0, Global.VP.x)
	position.y = wrapf(position.y, 0.0, Global.VP.y)

func get_input():
	var dir = Vector2.ZERO
	$Exhaust.hide()
	if Input.is_action_pressed("up"):
		$Exhaust.show()
		dir += Vector2(0, -1.5)
	if Input.is_action_pressed("down"):
		dir += Vector2(0, 1.0)
	if Input.is_action_pressed("left"):
		rotation_degrees -= rot_speed
	if Input.is_action_pressed("right"):
		rotation_degrees += rot_speed
	if Input.is_action_just_pressed("shoot"):
		shoot()
	return dir.rotated(rotation)

func shoot():
	Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null:
		if Global.bullets >= 0:
			var bullet = Bullet.instance()
			Effects.add_child(bullet)
			bullet.rotation = rotation
			bullet.position = global_position + nose.rotated(rotation)
			$Shoot_Sound.playing = true
			Global.update_bullets()

func damage(d):
	health -= d
	Global.update_hp(d)
	if health <= 0:
		Global.update_score(-100)
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			explosion.global_position = global_position
			Effects.add_child(explosion)
			$Explosion.playing = true
			hide()
			yield(explosion, "animation_finished")
			Global.update_lives()
			Global.health = 100
			Global.update_hp(0)
			Global.bullets = 50
			Global.update_bullets()
		queue_free()


func _on_Area2D_body_entered(body):
	if body.name != "Player":
		if body.has_method("damage"):
			body.damage(100)
		damage(100)

func _on_Shoot_Sound_finished():
	$Shoot_Sound.playing = false

func _on_Explosion_finished():
	$Explosion.playing = false
