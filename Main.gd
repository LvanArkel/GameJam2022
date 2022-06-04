extends Node2D

var Coin = load("res://Scenes/Coin.tscn")

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

func spawn_coin(position):
	var rand = randi() % 10
	
	if rand < 3:
		var coin = Coin.instance()
		coin.position = position
		add_child(coin)


func _on_Enemy_enemy_death(pos):
	spawn_coin(pos)
	$Player.enemies_left -= 1
	$Player.update_hud()
	pass # Replace with function body.


func _on_WaveController_next_wave(wave_number, enemies_left):
	print("Next wave number: " + str(wave_number))
	$Player.wave = wave_number
	$Player.enemies_left = enemies_left
	$Player.update_hud()
	pass # Replace with function body.
