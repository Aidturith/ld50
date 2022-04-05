extends KinematicBody2D

export var paused := true
export var max_health := 100
export var health := 100
export var speed := 250


func resume():
	paused = false
	for timer in $Timers.get_children():
		timer.start()
