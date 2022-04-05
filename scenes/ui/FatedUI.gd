extends VBoxContainer

onready var points_label = $PointsLabel
onready var points_bar = $PointsBar

# onready var max_points : int = $AllocatePoints.max_value
export var points := 0


func _ready():
	points_bar.max_value = points
	points_label.text = points_label(points)
	if owner:
		free_slider_queue()
		instanciate_sliders()


func free_slider_queue():
	for slider in $EventBox.get_children():
		slider.queue_free()


func instanciate_sliders():
	var max_points = points_bar.max_value
	var slider_scene = load("res://scenes/ui/EventSlider.tscn")
	for event in owner.get_node("EventScheduler/Events").get_children():
		var tooltip = event.title + "\n" + event.description
		var slider = slider_scene.instance()
		slider.connect("points_allocated", self, 
			"_on_EventSlider_points_allocated")
		slider.event = event
		slider.max_points = max_points
		slider.remaining = max_points
		slider.value = event.schedule_at
		slider.color = Color(1, 0.9, 0, 0.75)
		# slider.add_icon_override('toto', event.icon)
		slider.set("custom_styles/grabber", event.icon)
		slider.set("custom_styles/grabber_highlight", event.icon)
		slider.set_tooltip(tooltip)
		# source, action, target
		# TODO setup custom tooltips (mobile friendly too)
		$EventBox.add_child(slider)

func points_label(seconds):
	return str(seconds) + " secondes ᴀᴀᴀà allouer"
	

func _on_EventSlider_points_allocated():
	var max_points = points_bar.max_value
	var total_spent = 0
	for slider in $EventBox.get_children():
		var nb_points = min(slider.allocated, max_points)
		total_spent += nb_points
	var remaining = max_points - total_spent
	for slider in $EventBox.get_children():
		slider.remaining = remaining
		slider.update()
	points_bar.value = remaining
	points_label.text = points_label(remaining)


func _on_Start_pressed():
	var scheduler = owner.get_node("EventScheduler")
	scheduler.resume()
	get_tree().call_group("entities", "resume")
	get_parent().visible = false


func _on_Reset_pressed():
	for slider in $EventBox.get_children():
		slider.value = slider.initial_value
