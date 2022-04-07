extends Node2D

# var attack_cd := 1.0
var attack_dmg := 30
var attack_length := 20
var attack_direction := Vector2.ZERO

func _ready():
	# $Timers/AttackCD.time_left = attack_cd
	pass

func attack(direction):
	if direction != Vector2.ZERO:
		rotation = direction.angle()
		attack_direction = direction
	#if direction != Vector2.ZERO:
	#	#$RayCast2D.cast_to = direction * attack_length
	#	#$Sprite.rotation = direction.angle() - deg2rad(90)
	#	rotation = direction.angle() - deg2rad(90)
	if $Timers/AttackCD.is_stopped():
		$Timers/AttackCD.start()
		$AnimationPlayer.play("Attack")
		#var target = $RayCast2D.get_collider()
		#print("attack")
		#for target in $HitBox.get_overlapping_bodies():
		#	print(target.name)
		#	if target.name == "Squid":
		##if target and target.name.find("Squid") >= 0:
		#		print_debug("attack ", target.name)
		#		target.hit(attack_dmg)


func _on_HitBox_body_entered(body):
	if "Squid" in body.name:
		print_debug("attack ", body.name)
		body.hit(attack_dmg, attack_direction)
