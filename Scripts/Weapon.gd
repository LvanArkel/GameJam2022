extends Node2D

signal fire_weapon(amount, spread)

# Declare member variables here. Examples:
var fire_amount
var spread

var ammo

func init(firing_speed, spread, amount=1):
	$Cooldown.wait_time = firing_speed
	self.spread = spread
	self.fire_amount = amount
	self.ammo = 20
	
func init_texture(texture_path, texture_scale, muzzle_position):
	var texture = load(texture_path)
	$Sprite.texture = texture
	$Sprite.scale = texture_scale*Vector2(1,1)
	$Muzzle.position = muzzle_position
	
func re_init():
	$Cooldown.start()

# Called when the node enters the scene tree for the first time.
func can_fire():
	return $Cooldown.is_stopped()

func _input(event):
	if event.is_action_pressed("action"):
		shoot()

func _on_Cooldown_timeout():
	if Input.is_action_pressed("action"):
		shoot()

func shoot():
	if self.ammo <= 0:
		return
	var firing_amount = min(fire_amount, ammo)
	self.ammo -= firing_amount
	emit_signal("fire_weapon", firing_amount, spread)
	$Cooldown.start()
