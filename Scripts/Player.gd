extends KinematicBody2D

export (PackedScene) var Bullet
export (PackedScene) var Weapon


# constants
export var speed = 250
var screen_size

# variables
var weapons
var current_weapon

# signals
signal hit
signal spawn_bullet(bullet)

func _ready():
	screen_size = get_viewport_rect().size
	init_weapons()

func init_weapons():
	current_weapon = 0
	var pistol = Weapon.instance()
	pistol.init("res://assets/sprites/test_gun.png", 0.5, 10)
	pistol.connect("fire_weapon", self, "_on_Weapon_fire_weapon")
	var shotgun = Weapon.instance()
	shotgun.init("res://assets/sprites/test_shotgun.png", 1, 40, 5)
	shotgun.connect("fire_weapon", self, "_on_Weapon_fire_weapon")
	var rifle = Weapon.instance()
	rifle.init("res://assets/sprites/test_rifle.png", 0.2, 20)
	rifle.connect("fire_weapon", self, "_on_Weapon_fire_weapon")
	weapons = [pistol, shotgun, rifle]
	$WeaponSlot.add_child(weapons[current_weapon])

func _process(delta):
	$WeaponSlot.look_at(get_global_mouse_position())	


func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.	
	
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("move_down"):
		velocity.y += speed
	if Input.is_action_pressed("move_up"):
		velocity.y -= speed

	move_and_slide(velocity)


func _on_Player_body_entered(body):
	emit_signal("hit")
	$CollisionShape.set_deferred("disabled", true)

func _input(event):
	if event.is_action_pressed("scroll_forward"):
		current_weapon = (current_weapon + 1) % len(weapons)
	elif event.is_action_pressed("scroll_backward"):
		current_weapon = (current_weapon - 1) % len(weapons)
	else:
		return
	print("Switching to " + str(current_weapon))	
	var weapon = $WeaponSlot/Weapon
	$WeaponSlot.remove_child(weapon)
	$WeaponSlot.add_child(weapons[current_weapon])

func shoot(amount, spread):
	if not $WeaponSlot/Weapon.can_fire():
		return
	var bullet = Bullet.instance()
	var rotation = $WeaponSlot.global_rotation
	var barrel_length = $WeaponSlot/Weapon.barrel_length
	bullet.position = $WeaponSlot.global_position + barrel_length*Vector2(cos(rotation), sin(rotation))
	bullet.rotation = rotation
	emit_signal("spawn_bullet", bullet)
	$WeaponSlot/Weapon.shoot_bullet()



func _on_Weapon_fire_weapon(amount, spread):
	shoot(amount, spread)
