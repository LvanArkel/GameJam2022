extends Node2D

export (PackedScene) var Bullet

signal spawn_bullet(bullet)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$WeaponSlot.look_at(get_global_mouse_position())

func _input(event):
	if event.is_action_pressed("action"):
		shoot()

func shoot():
	if not $WeaponSlot/Weapon.can_fire():
		return
	var bullet = Bullet.instance()
	var rotation = $WeaponSlot.global_rotation
	var barrel_length = $WeaponSlot/Weapon.barrel_length
	bullet.position = $WeaponSlot.global_position + barrel_length*Vector2(cos(rotation), sin(rotation))
	bullet.rotation = rotation
	emit_signal("spawn_bullet", bullet)
	$WeaponSlot/Weapon.shoot_bullet()

