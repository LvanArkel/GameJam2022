extends Node2D

onready var level = load("res://Scenes/Levels/Motherboard.tscn")

export (Array, AudioStreamMP3) var game_over_sounds

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func show_death_screen(score):
	$GameOverSound.stream = game_over_sounds[randi() % len(game_over_sounds)]
	$GameOverSound.play()
	$SplashScreen.visible = false
	$Level.get_child(0).queue_free()
	$DeathScreen/BottomText.text = "Score: " + str(score)
	$DeathScreen.visible = true
	
	
func restart():
	$GameOverSound.stop()
	$DeathScreen.visible = false
	$SplashScreen.visible = true
	$StartTimer.start()
	$StartSound.play()


func _on_StartTimer_timeout():
	var level_inst = level.instance()
	$Level.add_child(level_inst)
	$SplashScreen.visible = false


func _on_Button_button_down():
	restart()


func _on_QuitButton_button_down():
	get_tree().quit()
