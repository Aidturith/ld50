extends HSlider

onready var scheduler = owner.get_node("EventScheduler")
onready var events = owner.get_node("EventScheduler/Events")


func _process(delta):
	update()


func _draw():
	for event in events.get_children():
		var time = scheduler.time
		var scheduled_at = event.schedule_at
		var pos = Vector2(rect_size.x * ((scheduled_at - time) / max_value), 20)
		draw_texture(event.icon, pos)
