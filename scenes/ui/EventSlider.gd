extends HSlider

var event
var color : Color
var icon : String
var font : DynamicFont

var initial_value := 0
var max_points := 0
var remaining := 0
var allocated := 0

signal points_allocated

func _ready():
	initial_value = value
	font = load("res://resources/fonts/red_hat_mono.tres")
	#font = DynamicFont.new()
	#font.font_data = load("res://resources/fonts/red_hat_mono.tres")
	font.size = 20


func _physics_process(_delta):
	if value < min_bound():
		value = min_bound()
	elif value > max_bound():
		value = max_bound()


func _draw():
	# var a = Vector2(rect_size.x * (min_bound() / max_value), 20)
	# var b = Vector2(rect_size.x * (max_bound() / max_value), 20)
	var b = Vector2(rect_size.x * (initial_value / max_value), 20)
	var a = Vector2(rect_size.x * (value / max_value), 20)
	draw_line(a, b, color, 3.0, true)
	var grabber_x = rect_size.x * (value / max_value)
	var c = Vector2(grabber_x + 32, 25)
	draw_string(font, c, str(value))
	

#func _make_custom_tooltip(text):
	# This exists, and is a Control node, with a panel-container and label inside of it
	#var tooltip = preload("res://scenes/ui/ToolTip.tscn").instance()
	#tooltip.get_node("Label").text = text
	#return tooltip
	
func _make_custom_tooltip(text):
	var label = Label.new()
	label.text = text
	label.set_position(Vector2(50, 100))
	return label


func min_bound():
	return max(0, initial_value - (remaining + allocated))


func max_bound():
	return min(initial_value + (remaining + allocated), max_value)


func _on_EventSlider_value_changed(value):
	if value >= min_bound() and value <= max_bound():
		allocated = abs(value - initial_value)
		emit_signal("points_allocated")
		if event:
			event.schedule_at = value
		
