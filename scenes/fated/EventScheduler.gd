extends Node2D

export var paused := true

# TODO use os time ?
onready var time := 0.0
onready var label := $EventLabel
onready var label_anim := $EventLabel/AnimationPlayer


func _process(delta):
	if paused:
		return
	time += delta
	

func resume():
	$Timer.start()
	paused = false


# check periodic events
func _on_Timer_timeout():
	for event in $Events.get_children():
		if time > event.schedule_at + event.delay:
			handle_event(event)


func handle_event(event):
	# TODO handle groups too
	#for source_path in event.sources:
	#	for target_path in event.targets:
	var action = event.action
	var source = event.get_node(event.source)
	var target = event.get_node(event.target)
	if source and target:
		label.text = event.title
		label_anim.play("EventCall")
		print_debug(source, " ", action, " ", target)
		# target.emit_signal("some_signal")
		source.call_deferred(action, target)
	else:
		print_debug("event trigger but no source or target")
	event.queue_free()
