extends Node2D

signal next_wave(wave_number, enemies_left)
signal spawn_enemy(enemy)

export (int) var max_enemies = 12
export (int) var starting_enemies = 0

var current_wave_idx = 0
var current_wave
var enemies_left = 0
var enemies_alive = 0
var waves = []
var positions = []

var _previous_enemy = 0

var wave_class = load("res://Scripts/Wave.gd")
var enemy_scene = load("res://Scenes/Enemy.tscn")
var trojan_scene = load("res://Scenes/Trojan.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_positions()
	enemies_alive = starting_enemies
	waves.append(wave_class.new(5, 1, 0))
	waves.append(wave_class.new(8, 0, 0))
	waves.append(wave_class.new(5, 3, 0))
	waves.append(wave_class.new(10, 3, 0))
	waves.append(wave_class.new(15, 5, 0))
	waves.append(wave_class.new(20, 8, 0))
	waves.append(wave_class.new(20, 10, 0))
	waves.append(wave_class.new(30, 15, 0))

	next_wave()


func next_wave():
	if len(waves) == current_wave_idx:
		current_wave = wave_class.new(30, 15, 0)
	else:
		current_wave = waves[current_wave_idx]
	
	enemies_left = current_wave.ghosts + current_wave.trojans

	current_wave_idx += 1
	
	emit_signal("next_wave", current_wave_idx, enemies_left)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $SpawnTimer.is_stopped():
		#TIME TO SPAWN
		spawn()
		$SpawnTimer.start()
		
func get_positions():
	var children = get_children()
	
	for child in children:
		if child.name != "SpawnTimer" && child.name != "WaveTimer":
			positions.append(child.position)

func spawn():
	if enemies_alive >= max_enemies:
		# too many enemies alive
		# do nothing
		return
	
	if enemies_left > 0:
		var enemy
		
		if _previous_enemy == 0 && current_wave.trojans > 0:
			enemy = trojan_scene.instance()
			current_wave.trojans -= 1
			_previous_enemy = 1
		else:
			enemy = enemy_scene.instance()
			current_wave.ghosts -= 1
			_previous_enemy = 0
		
		# TODO random pos
		
		enemy.position = get_random_pos()
		enemies_left -= 1
		emit_signal("spawn_enemy", enemy)
	else:
		print("Wave done")
		next_wave()

func get_random_pos() -> Vector2:
	var idx = randi() % positions.size()
	return positions[idx]
