extends Node2D

signal fire_weapon

# Declare member variables here. Examples:
var cooldown = 0.5

var spread = 10
var barrel_length = 30

func init(texture_path):
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(texture_path)
	texture.create_from_image(image)
	$Sprite.texture = texture

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
	emit_signal("fire_weapon")
