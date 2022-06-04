extends Node2D

func _ready():
	$Player.hud = $Hud
	$Player.update_hud()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$DebugHud/Labels/WeaponCooldown.text = str($Player/WeaponSlot/Weapon/Cooldown.time_left)
	#DebugHud/Labels/PistolAmmo.text = "Pistol: " + str($Player.weapons[0].ammo)
	#$DebugHud/Labels/ShotgunAmmo.text = "Shotgun: " + str($Player.weapons[1].ammo)
	#$DebugHud/Labels/RifleAmmo.text = "Rifle: " + str($Player.weapons[2].ammo)
	pass


func _on_Player_spawn_bullet(bullets):
	for bullet in bullets:
		bullet.bullet_speed = $Bullets.get_bullet_speed()
		$Bullets.add_child(bullet)
