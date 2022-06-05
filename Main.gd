extends Node2D

onready var level = load("res://Scenes/Levels/Motherboard.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_StartTimer_timeout():
	var level_inst = level.instance()
	$Level.add_child(level_inst)
	$SplashScreen.visible = false
