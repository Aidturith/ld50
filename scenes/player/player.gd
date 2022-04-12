extends "res://scenes/Entity.gd"

export onready var statues := []

onready var health_bar = owner.get_node("UI/HealthBar")
onready var statues_ui = owner.get_node("UI/Statues")

var last_direction := Vector2.DOWN

func _ready():
	# Engine.time_scale = 0.1
	max_health = 100
	health = 100
	speed = 200
	health_bar.max_value = max_health

func _physics_process(delta):
	if paused:
		return
	# move
	var right := Input.get_action_strength("ui_right")
	var left := Input.get_action_strength("ui_left")
	var down := Input.get_action_strength("ui_down")
	var up := Input.get_action_strength("ui_up")
	var input_vector := Vector2(right - left, down - up)
	var direction := input_vector.normalized()
	if direction != Vector2.ZERO:
		last_direction = direction
	move_and_slide(direction * speed)

	# sword
	if Input.is_action_just_pressed("action_1"):
		$Sword.attack(last_direction)
	
	# look_at(get_global_mouse_position())
	#if Input.is_action_pressed("player_shoot"):
	# if Input.is_action_pressed("mouse1"):
	# 	if $bullet_cooldown.time_left == 0:
	# 		shoot()

# func shoot():
# 	var fired = bullet.instance()
# 	fired.start_at(rotation, position)
# 	$bullet_container.add_child(fired)
# 	$bullet_cooldown.start()

#func shoot(delta):
#	var fired  = bullet.instance()
#	fired.position = get_global_position()
#	fired.rotation_degrees = rotation_degrees
#	fired.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
#	get_tree().get_root().call_deferred("add_child", fired)


func status_inflicted(status):
	statues.append(status)
	var image = Image.new()
	image.load("res://assets/textures/ui/poison_icon.png")
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	var icon = TextureRect.new()
	icon.texture = texture
	statues_ui.add_child(icon)


func _on_Statues_timeout():
	for status in statues:
		if status == "poison":
			hit(1)

func hit(damage):
	print_debug("hit ", damage, " ", health)
	health -= damage
	health_bar.value = health
	if health <= 0:
		game_over()
	$UI/Player.play("Hit")
	# spawn a new label
	var label_scene = load("res://scenes/ui/HitLabel.tscn")
	var label = label_scene.instance()
	label.text = String(damage)
	label.get_node('AnimationPlayer').play('MoveUp')
	add_child(label)
	yield(get_tree().create_timer(2.0), "timeout")
	label.queue_free()
	
	
func game_over():
	print_debug("oh noes")
	get_tree().reload_current_scene()
