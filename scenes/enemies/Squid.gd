extends "res://scenes/Entity.gd"

var player

var rng := RandomNumberGenerator.new()

var direction : Vector2
var last_direction := Vector2(0, 1)
var bounce_countdown := 0

var base_damage := 10

var target = null


func _ready():
	max_health = 100
	health = 100
	speed = 100
	player = owner.get_node('Player')
	# player = get_tree().root.get_node("Root/Player")
	# player =  get_tree().get_current_scene()
	# get_tree().get_root().find_node("node_name")
	rng.randomize()
	
	
func _physics_process(delta):
	if paused:
		return 
	var movement = direction * speed * delta
	var collision = move_and_collide(movement)
	if collision and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)


func _on_Behaviour_timeout():
	#if target:
	#	var target_position = target.position - position
	#	direction = Vector2.ZERO
	#	direction = target_position.normalized()
	#elif bounce_countdown == 0:
	if bounce_countdown == 0:
		var move_rng = rng.randf()
		#if move_rng < 0.05:
		#	print("stop")
		#	direction = Vector2.ZERO
		if move_rng < 0.10:
			print("turn")
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		#elif move_rng > 0.95:
		#	# TODO refacto me in fated module
		#	player = owner.get_node('Player')
		#	print("poison", player)
		#	inflict_poison(player)
		elif move_rng > 0.90:
			$Attacks/Player.play("Fart")
	
#func _on_Behaviour_timeout():
#	# Calculate the position of the player relative to the skeleton
#	var player_relative_position = player.position - position
#	
#	if player_relative_position.length() <= 16:
#		# If player is near, don't move but turn toward it
#		direction = Vector2.ZERO
#		last_direction = player_relative_position.normalized()
#	elif player_relative_position.length() <= 100 and bounce_countdown == 0:
#		# If player is within range, move toward it
#		direction = player_relative_position.normalized()
#	elif bounce_countdown == 0:
#		# If player is too far, randomly decide whether to stand still or where to move
#		var random_number = rng.randf()
#		if random_number < 0.05:
#			direction = Vector2.ZERO
#		elif random_number < 0.1:
#			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
#	
	# Update bounce countdown
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1

func hit(damage):
	health -= damage
	if health > 0:
		$Player.play("Hit")
	else:
		get_tree().queue_delete(self)


func _on_Fart_body_entered(body):
	if body.name == "Player":
		body.hit(base_damage)


func _on_Detection_body_entered(body):
	if body.name == "Player":
		target = body
		

func _on_Detection_body_exited(body):
	if body == target:
		target = null


func poison(target):
	if target.name == "Player":
		$Audio/CloudBig.play()
		target.status_inflicted("poison")
