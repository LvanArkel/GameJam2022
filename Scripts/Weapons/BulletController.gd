extends Node2D

const maxGameState = 4

export (float) var totalSpeed

var gameState


# Called when the node enters the scene tree for the first time.
func _ready():
	gameState = 0

func increment_game_state():
	if gameState < maxGameState-1:
		gameState += 1
	update_bullets()

func reset_game_state():
	gameState = 0
	update_bullets()
	
func get_bullet_speed():
	return totalSpeed * (maxGameState - gameState) / maxGameState

func update_bullets():
	var speed = get_bullet_speed()
	for child in get_children():
		child.bullet_speed = speed


func _on_ChaosController_increase_bullet_time():
	increment_game_state()
