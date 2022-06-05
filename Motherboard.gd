extends Node2D

var Coin = load("res://Scenes/Coin.tscn")

func _ready():
	$Player.hud = $Hud
	$Player.update_hud()
	init_chaos_controller()
	$Enemies.nav_mesh = $NavMesh
	for child in $Breakables.get_children():
		child.chaos_controller = $ChaosController

func init_chaos_controller():
	$ChaosController.player_sprite = $Player/Sprite


func _on_Player_spawn_bullet(bullets):
	for bullet in bullets:
		bullet.bullet_speed = $Bullets.bullet_speed
		$Bullets.add_child(bullet)

func spawn_coin(position):
	var rand = randi() % 10
	
	if rand < 3:
		var coin = Coin.instance()
		coin.position = position
		add_child(coin)


func _on_Enemy_enemy_death(pos, health):
	print($Player)
	$EnemyDeathSound.position = pos
	$EnemyDeathSound.play()
	spawn_coin(pos)
	$Player.enemies_left -= 1
	$Player.score += health * 10
	$Player.update_hud()


func _on_WaveController_next_wave(wave_number, enemies_left):
	print("Next wave number: " + str(wave_number))
	$Player.wave = wave_number
	$Player.enemies_left = enemies_left
	$Player.update_hud()


func _on_Player_repair_chaos(chaos_type):
	print("Repair chaos!")
	$ChaosController.repair_chaos(chaos_type)
