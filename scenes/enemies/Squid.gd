extends "res://scenes/Entity.gd"

var player

var rng := RandomNumberGenerator.new()

var direction : Vector2
var last_direction := Vector2(0, 1)
var bounce_countdown := 0

var base_damage := 10

var knockback := Vector2.ZERO

# nodes
onready var health_bar = $UI/HealthBar


func _ready():
	max_health = 100
	health = max_health
	health_bar.value = max_health
	speed = 75
	player = owner.get_node('Player')
	rng.randomize()
	$AnimationPlayer.play("Float")
	
	
func _physics_process(delta):
	if paused:
		return
	var movement = direction * speed * delta
	if knockback.length() > 0.1:
		movement = knockback * speed * delta
		knockback = knockback.linear_interpolate(Vector2.ZERO, 0.1)
	var collision = move_and_collide(movement)
	if collision and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)


func _on_Behaviour_timeout():
	if bounce_countdown == 0:
		var move_rng = rng.randf()
		if move_rng < 0.10:
			print("turn")
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		elif move_rng > 0.90:
			$Attacks/Player.play("Fart")
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1


func hit(damage, _direction):
	knockback = _direction * 3
	health -= damage
	if health > 0:
		health_bar.visible = true
		health_bar.value = health
		health_bar.get_node("AnimationPlayer").play("Hit")
	else:
		get_tree().queue_delete(self)


func _on_Fart_body_entered(body):
	if body.name == "Player":
		body.hit(base_damage)


func poison(target):
	if target.name == "Player":
		$Audio/CloudBig.play()
		target.status_inflicted("poison")
