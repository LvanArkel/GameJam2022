extends Node2D

signal next_wave(wave_number, enemies_left)

export (int) var max_enemies = 8
export (int) var starting_enemies = 0

var current_wave = 0
var enemies_left = 0
var enemies_alive = 0
var waves = []
		
var wave_class = load("res://Scripts/Wave.gd")
var enemy_scene = load("res://Scenes/Enemy.tscn")

onready var enemy_node = get_node("/root/Main/Enemies")

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies_alive = starting_enemies
	waves.append(wave_class.new(10, 0, 0))
	waves.append(wave_class.new(15, 0, 0))
	waves.append(wave_class.new(25, 0, 0))
	#waves.append(wave_class.new(5, 3, 0))
	#waves.append(wave_class.new(10, 0, 1))
	#waves.append(wave_class.new(10, 5, 1))

	next_wave()


func next_wave():
	var wave = waves[current_wave]
	enemies_left = wave.ghosts

	current_wave += 1
	
	emit_signal("next_wave", current_wave, enemies_left)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var child = enemy_node.get_child_count()
	
	if $SpawnTimer.is_stopped():
		#TIME TO SPAWN
		spawn()
		$SpawnTimer.start()

func spawn():
	if enemies_alive >= max_enemies:
		# too many enemies alive
		# do nothing
		return
	
	if enemies_left > 0:
		var enemy = enemy_scene.instance()
		enemy.position = position
		enemies_left -= 1
		
		enemy_node.add_child(enemy)
	else:
		print("Wave done")
		next_wave()
