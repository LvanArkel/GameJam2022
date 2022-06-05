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
var buy_type = "ammo"
var chaos_repair_type = 0
export (int) var money
export (int) var health

var enemies_left
var wave

# signals
signal spawn_bullet(bullet)
signal repair_chaos(chaos_type)

func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	init_weapons()
	money = 40
	health = 5

func init_weapons():
	current_weapon = 0
	var pistol = Weapon.instance()
	pistol.init(0.5, 5)
	pistol.init_texture("res://assets/sprites/pistol.png", 0.4, Vector2(23,-5))
	pistol.connect("fire_weapon", self, "_on_Weapon_fire_weapon")
	var shotgun = Weapon.instance()
	shotgun.init(1, 30, 5)
	shotgun.init_texture("res://assets/sprites/shotgun.png", 0.8, Vector2(45,-3))
	shotgun.connect("fire_weapon", self, "_on_Weapon_fire_weapon")
	var rifle = Weapon.instance()
	rifle.init(0.2, 30)
	rifle.init_texture("res://assets/sprites/rifle.png", 0.8, Vector2(45,-2))
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
	if weaponRotation < 45 or weaponRotation > 315:
		$Sprite.animation = "Right"
	elif weaponRotation < 135:
		$Sprite.animation = "Down"
	elif weaponRotation < 225:
		$Sprite.animation = "Left"
	else:
		$Sprite.animation = "Up"


func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.	
	
	if $FreezeCooldown.is_stopped():
		if Input.is_action_pressed("move_right"):
			velocity.x += speed
		if Input.is_action_pressed("move_left"):
			velocity.x -= speed
		if Input.is_action_pressed("move_down"):
			velocity.y += speed
		if Input.is_action_pressed("move_up"):
			velocity.y -= speed
	
	if velocity != Vector2.ZERO:
		$Sprite.playing = true
	else:
		$Sprite.playing = false
		$Sprite.frame = 0

	move_and_slide(velocity)


func _on_Player_body_entered(body):
	emit_signal("hit")
	$CollisionShape.set_deferred("disabled", true)

func _input(event):
	if not $FreezeCooldown.is_stopped():
		return
	if event.is_action_pressed("scroll_forward"):
		switch_weapon(1)
	elif event.is_action_pressed("scroll_backward"):
		switch_weapon(2)
	elif event.is_action_pressed("interact"):
		if can_buy and money >= 10:
			money -= 10
			if buy_type == "ammo":
				weapons[current_weapon].ammo += 10
			elif buy_type == "chaos":
				print("repair chaos")
				emit_signal("repair_chaos", chaos_repair_type)
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
	hud.update_player_info(money, health, current_weapon, ammos, wave, enemies_left)
	
func damage(amount):
	if $Timer.is_stopped():
		health -= amount
		update_hud()
		
		if health <= 0:
			die()
		else:
			$DmgSound.play()
			$Timer.start()
	
func die():
	print("Player died")
	var main = $"/root/Main".show_death_screen()

func _on_Weapon_fire_weapon(amount, spread):
	shoot(amount, spread)
	$GunSound.play()
	


func _on_store_body_entered(body):
	print("oof")
	if body.is_in_group("Player"):
		can_buy = true
		buy_type = "ammo"
		$PurchaseSprite.visible = can_buy


func _on_store_body_exited(body):
	if body.is_in_group("Player"):
		can_buy = false
		$PurchaseSprite.visible = can_buy


func _on_ChaosController_remove_data(type, amount):
	print(type, amount)
	if type == 3:
		money = max(0, money-amount)
	else:
		weapons[type].ammo = max(0, weapons[type].ammo-amount)
	update_hud()


func _on_ChaosController_freeze_player(duration):
	$FreezeCooldown.start(duration)

