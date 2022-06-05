extends Node2D

var Coin = load("res://Scenes/Coin.tscn")

func _ready():
	$Player.hud = $Hud
	$Player.update_hud()
	init_chaos_controller()

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


func _on_Enemy_enemy_death(pos):
	print($Player)
	spawn_coin(pos)
	$Player.enemies_left -= 1
	$Player.update_hud()


func _on_WaveController_next_wave(wave_number, enemies_left):
	print("Next wave number: " + str(wave_number))
	$Player.wave = wave_number
	$Player.enemies_left = enemies_left
	$Player.update_hud()
