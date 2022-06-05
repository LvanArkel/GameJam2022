extends Node

export (Material) var CorruptMaterial

var chaos_states = [0,0,0,0,0]
const max_chaos_state = 4


signal increase_bullet_time(chaos_state)
signal remove_data(type, amount)
signal update_enemy_texture(material, visible)
signal freeze_player(duration)
signal chaos_modified(states)

var player_sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _input(event):
	return
	var just_pressed = event.is_pressed() and not event.is_echo()
	if not just_pressed:
		return
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
	elif Input.is_key_pressed(KEY_6):
		repair_chaos(0)
	elif Input.is_key_pressed(KEY_7):
		repair_chaos(1)
	elif Input.is_key_pressed(KEY_8):
		repair_chaos(2)
	elif Input.is_key_pressed(KEY_9):
		repair_chaos(3)
	elif Input.is_key_pressed(KEY_0):
		repair_chaos(4)

func trigger_chaos(type):
	if type == 0:
		set_chaos_message("CPU damaged", "Bullet physics affected")
		bullet_time()
	elif type == 1:
		set_chaos_message("GPU damaged", "Visuals affected")
		change_screen_color()
	elif type == 2:
		set_chaos_message("RAM damaged", "Some data may be lost")
		remove_data()
	elif type == 3:
		set_chaos_message("Hard drive damaged", "Sprites might be missing")
		hide_sprite()
	elif type == 4:
		set_chaos_message("Power supply damaged", "No power to move")
		freeze_input()
	$AnimationPlayer.play("ChaosMessage_fadeIn")
	$ChaosMessageTimer.start(1.5)
	emit_signal("chaos_modified", chaos_states)
	var choice = randf()
	if choice < 0.5:
		$DebuffSounds/DebuffSound1.play()
	else:
		$DebuffSounds/DebuffSound2.play()
	

func repair_chaos(type):
	if type == 0:
		emit_signal("increase_bullet_time", 0)
		set_chaos_message("CPU repaired", "Bullet physics restored")
	elif type == 1:
		$CanvasModulate.visible = false
		$MonochromeFilter.visible = false
		set_chaos_message("GPU repaired", "Visuals restored")
	elif type == 2:
		set_chaos_message("RAM repaired", "Data lost penalty reset")
	elif type == 3:
		player_sprite.material = null
		player_sprite.visible = true
		emit_signal("update_enemy_texture", null, true)
		set_chaos_message("Hard drive repaired", "Sprites restored")
	elif type == 4:
		set_chaos_message("Power supply damaged", "Movement penalty reset")
	chaos_states[type] = 0
	$AnimationPlayer.play("ChaosMessage_fadeIn")
	$ChaosMessageTimer.start(1.5)
	emit_signal("chaos_modified", chaos_states)

func set_chaos_message(title, content):
	$MessageBox/ChaosMessage/ChaosTitle.text = title
	$MessageBox/ChaosMessage/ChaosContent.text = content

#Reduces the speed of bullets for a while
func bullet_time():
	if chaos_states[0] >= max_chaos_state:
		return
	chaos_states[0] += 1
	emit_signal("increase_bullet_time", chaos_states[0])

#Modulate the screen color such that everything is a different color
func change_screen_color():
	#Change for black/white, chance for random color
	if chaos_states[1] == 0:
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
	elif chaos_states[1] == 1:
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
	elif chaos_states[1] == 2:
		$CanvasModulate.visible = false
		$MonochromeFilter.visible = true
		$MonochromeFilter.material.set_shader_param("invert", false)
	elif chaos_states[1] == 3:
		$MonochromeFilter.visible = true
		$MonochromeFilter.material.set_shader_param("invert", true)
	else:
		return
	chaos_states[1] += 1

#Remove some data (In this case some money or Ammo) from the player
func remove_data():
	if chaos_states[2] < max_chaos_state:
		chaos_states[2] += 1
	var removable = randi() % 4
	var amount = int(randf() * 2*chaos_states[2])+1
	emit_signal("remove_data", removable, amount)
	
#Hide some random sprites, and replace them with particles.
func hide_sprite():
	if chaos_states[3] == 0:
		player_sprite.material = CorruptMaterial
	elif chaos_states[3] == 1:
		player_sprite.visible = false
	elif chaos_states[3] == 2:
		emit_signal("update_enemy_texture", CorruptMaterial, true)
	elif chaos_states[3] == 3:
		emit_signal("update_enemy_texture", null, false)
	else:
		return
	chaos_states[3] += 1

#Freeze input for a while
func freeze_input():
	if chaos_states[4] < max_chaos_state:
		chaos_states[4] += 1
	emit_signal("freeze_player", chaos_states[4]*0.5)


func _on_ChaosMessageTimer_timeout():
	$AnimationPlayer.play("ChaosMessage_fadeOut")
