extends Node2D

export (PackedScene) var Bullet
export (PackedScene) var Weapon

var weapons

# variables
export var speed = 500
var screen_size

# signals
signal hit
signal spawn_bullet(bullet)

func _ready():
	screen_size = get_viewport_rect().size
	init_weapons()

func init_weapons():
	var pistol = Weapon.instance()
	pistol.init("res://assets/sprites/test_gun.png")
	var shotgun = Weapon.instance()
	shotgun.init("res://assets/sprites/test_shotgun.png")
	var rifle = Weapon.instance()
	rifle.init("res://assets/sprites/test_rifle.png")
	weapons = [pistol, shotgun, rifle]
	$WeaponSlot.add_child(weapons[0])

func _process(delta):
	$WeaponSlot.look_at(get_global_mouse_position())	
	
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#$AnimatedSprite.play()
	else:
		pass
		#$AnimatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_Player_body_entered(body):
	emit_signal("hit")
	$CollisionShape.set_deferred("disabled", true)


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



func _on_Weapon_fire_weapon():
	shoot()
