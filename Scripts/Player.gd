extends KinematicBody2D

export (PackedScene) var Bullet
export (PackedScene) var Weapon


# constants
export var speed = 180
var screen_size

# other game objects
var hud
var weapons

# variables
var current_weapon
var can_buy
export (int) var money
export (int) var health

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
	pistol.init(0.5, 5)
	pistol.init_texture("res://assets/sprites/pistol.png", 0.4, Vector2(23,-5))
	pistol.connect("fire_weapon", self, "_on_Weapon_fire_weapon")
	var shotgun = Weapon.instance()
	shotgun.init(1, 30, 5)
	shotgun.init_texture("res://assets/sprites/shotgun.png", 1, Vector2(60,-5))
	shotgun.connect("fire_weapon", self, "_on_Weapon_fire_weapon")
	var rifle = Weapon.instance()
	rifle.init(0.2, 30)
	rifle.init_texture("res://assets/sprites/rifle.png", 1, Vector2(60,-4))
	rifle.connect("fire_weapon", self, "_on_Weapon_fire_weapon")
	weapons = [pistol, shotgun, rifle]
	$WeaponSlot.add_child(weapons[current_weapon])

func _process(delta):
	$WeaponSlot.look_at(get_global_mouse_position())
	var weaponRotation = fmod($WeaponSlot.rotation_degrees+360.0, 360.0)
	if weaponRotation > 90 and weaponRotation < 270:
		$WeaponSlot.scale = Vector2(1,-1)
	else:
		$WeaponSlot.scale = Vector2(1,1)


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
		switch_weapon(1)
	elif event.is_action_pressed("scroll_backward"):
		switch_weapon(2)
	elif event.is_action_pressed("interact"):
		if can_buy and money >= 10:
			money -= 10
			weapons[current_weapon].ammo += 10
			update_hud()

func switch_weapon(delta):
	current_weapon = (current_weapon + delta) % len(weapons)
	print("Switching to " + str(current_weapon))
	var weapon = $WeaponSlot/Weapon
	$WeaponSlot.remove_child(weapon)
	$WeaponSlot.add_child(weapons[current_weapon])
	update_hud()

func shoot(amount, spread):
	var bullets = []
	for i in range(amount):
		var bullet = Bullet.instance()
		var rotation = $WeaponSlot.global_rotation + spread * deg2rad(randf() - 0.5)
		bullet.position = $WeaponSlot/Weapon/Muzzle.global_position
		bullet.rotation = rotation
		bullets.append(bullet)
	emit_signal("spawn_bullet", bullets)
	update_hud()

func pickup_coin(value):
	money += value
	update_hud()
	
func update_hud():
	if hud == null:
		return
	var ammos = [weapons[0].ammo, weapons[1].ammo, weapons[2].ammo]
	hud.update_player_info(money, health, current_weapon, ammos)
	
	


func _on_Weapon_fire_weapon(amount, spread):
	shoot(amount, spread)
	


func _on_store_body_entered(body):
	if body.is_in_group("Player"):
		can_buy = true
		$PurchaseSprite.visible = can_buy


func _on_store_body_exited(body):
	if body.is_in_group("Player"):
		can_buy = false
		$PurchaseSprite.visible = can_buy
