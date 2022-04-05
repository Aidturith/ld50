extends Node2D

export var schedule_at : int
export var title := "An event to happen"
export(String, MULTILINE) var description := "With probably dear consequences"
export(Color, RGB) var color := Color(1, 1, 1)
export(Texture) var icon
export(NodePath) var source
export var action : String
export(NodePath) var target
export(String) var targets # group

var delay : int

func _ready():
	pass # Replace with function body.
