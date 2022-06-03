extends Node2D

signal fire_weapon(amount, spread)

# Declare member variables here. Examples:
var fire_amount
var spread
var barrel_length

var ammo

func init(texture_path, firing_speed, spread, barrel_length, amount=1):
	var texture = load(texture_path)
	$Sprite.texture = texture
	$Cooldown.wait_time = firing_speed
	self.spread = spread
	self.barrel_length = barrel_length
	self.fire_amount = amount
	
	self.ammo = 7
	
func re_init():
	$Cooldown.start()

# Called when the node enters the scene tree for the first time.
func can_fire():
	return $Cooldown.is_stopped()

func shoot_bullet():
	$Cooldown.start()

func _input(event):
	if event.is_action_pressed("action"):
		shoot()

func _on_Cooldown_timeout():
	if Input.is_action_pressed("action"):
		shoot()

func shoot():
	if self.ammo <= 0:
		return
	emit_signal("fire_weapon", min(fire_amount, ammo), spread)
	self.ammo -= min(fire_amount, ammo)
