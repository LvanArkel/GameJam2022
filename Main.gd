extends Node2D

onready var level = load("res://Scenes/Levels/Motherboard.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_death_screen():
	$SplashScreen.visible = false
	$Level.get_child(0).queue_free()
	$DeathScreen.visible = true
	
	
func restart():
	$DeathScreen.visible = false
	$SplashScreen.visible = true
	$StartTimer.start()


func _on_StartTimer_timeout():
	var level_inst = level.instance()
	$Level.add_child(level_inst)
	$SplashScreen.visible = false


func _on_Button_button_down():
	restart()
