extends Node2D

const maxGameState = 4

export (float) var totalSpeed = 400

var bullet_speed


# Called when the node enters the scene tree for the first time.
func _ready():
	set_bullet_speed(0)
	
func set_bullet_speed(chaos_state):
	bullet_speed =  totalSpeed * (maxGameState + 1 - chaos_state) / (maxGameState+1)

func update_bullets():
	for child in get_children():
		child.bullet_speed = bullet_speed


func _on_ChaosController_increase_bullet_time(chaos_state):
	set_bullet_speed(chaos_state)
	update_bullets()
