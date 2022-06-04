extends Node

var graphics_state = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _input(evt):
	if Input.is_key_pressed(KEY_1):
		trigger_chaos(0)
	elif Input.is_key_pressed(KEY_2):
		trigger_chaos(1)
	elif Input.is_key_pressed(KEY_3):
		trigger_chaos(2)
	elif Input.is_key_pressed(KEY_4):
		trigger_chaos(3)
	elif Input.is_key_pressed(KEY_5):
		trigger_chaos(4)

func trigger_chaos(type):
	if type == 0:
		bullet_time()
	elif type == 1:
		change_screen_color()
	elif type == 2:
		remove_data()
	elif type == 3:
		hide_sprite()
	elif type == 4:
		freeze_input()
	$AnimationPlayer.play("ChaosMessage_fadeIn")
	$ChaosMessageTimer.start(1.5)

#Reduces the speed of bullets for a while
func bullet_time():
	pass

#Modulate the screen color such that everything is a different color
func change_screen_color():
	#Change for black/white, chance for random color
	if graphics_state == 0:
		var to_chose = randf()
		var c = null
		if to_chose < 0.33:
			c = Color(1,1,0)
		elif to_chose < 0.67:
			c = Color(1,0,1)
		else:
			c = Color(0,1,1)
		$CanvasModulate.color = c
		$CanvasModulate.visible = true
		graphics_state = 1
	elif graphics_state == 1:
		var to_chose = randf()
		var c = null
		if to_chose < 0.33:
			c = Color(1,0,0)
		elif to_chose < 0.67:
			c = Color(0,1,0)
		else:
			c = Color(0,0,1)
		$CanvasModulate.color = c
		$CanvasModulate.visible = true
		graphics_state = 2
	elif graphics_state == 2:
		$CanvasModulate.visible = false
		$MonochromeFilter.visible = true
		graphics_state = 3
	elif graphics_state == 3:
		$MonochromeFilter.material.set_shader_param("invert", true)

#Remove some data (In this case some money or Ammo) from the player
func remove_data():
	pass
	
#Hide some random sprites, and replace them with particles.
func hide_sprite():
	pass

#Freeze input for a while
func freeze_input():
	pass


func _on_ChaosMessageTimer_timeout():
	$AnimationPlayer.play("ChaosMessage_fadeOut")
