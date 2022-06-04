extends KinematicBody2D

export (PackedScene) var Bullet
export (PackedScene) var Weapon


# constants
export var speed = 150
var screen_size

var hud

# variables
var weapons
var current_weapon

# signals
signal hit
signal spawn_bullet(bullet)

func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	init_weapons()

func init_weapons():
	current_weapon = 0
	var pistol = Weapon.instance()
	pistol.init("res://assets/sprites/test_gun.png", 0.5, 5, 30)
	pistol.connect("fire_weapon", self, "_on_Weapon_fire_weapon")
	var shotgun = Weapon.instance()
	shotgun.init("res://assets/sprites/test_shotgun.png", 1, 30, 50, 5)
	shotgun.connect("fire_weapon", self, "_on_Weapon_fire_weapon")
	var rifle = Weapon.instance()
	rifle.init("res://assets/sprites/test_rifle.png", 0.2, 30, 50)
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
	var bullets = []
	for i in range(amount):
		var bullet = Bullet.instance()
		var rotation = $WeaponSlot.global_rotation + spread * deg2rad(randf() - 0.5)
		var barrel_length = $WeaponSlot/Weapon.barrel_length
		bullet.position = $WeaponSlot.global_position + barrel_length*Vector2(cos(rotation), sin(rotation))
		bullet.rotation = rotation
		bullets.append(bullet)
	emit_signal("spawn_bullet", bullets)
	update_hud()
	
func update_hud():
	if hud == null:
		return
	var first_row = hud.get_node("Cols").get_node("Row1")
	var second_row = hud.get_node("Cols").get_node("Row2")
	second_row.get_node("PistolAmmoLabel").text = "= " + str(weapons[0].ammo)
	second_row.get_node("ShotgunAmmoLabel").text = "= " + str(weapons[1].ammo)
	second_row.get_node("RifleAmmoLabel").text = "= " + str(weapons[2].ammo)
	


func _on_Weapon_fire_weapon(amount, spread):
	shoot(amount, spread)
