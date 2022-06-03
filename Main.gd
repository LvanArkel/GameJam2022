extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Control/Labels/WeaponCooldown.text = str($Player/WeaponSlot/Weapon/Cooldown.time_left)
	$Control/Labels/PistolAmmo.text = "Pistol: " + str($Player.weapons[0].ammo)
	$Control/Labels/ShotgunAmmo.text = "Shotgun: " + str($Player.weapons[1].ammo)
	$Control/Labels/RifleAmmo.text = "Rifle: " + str($Player.weapons[2].ammo)


func _on_Player_spawn_bullet(bullets):
	for bullet in bullets:
		$Bullets.add_child(bullet)
