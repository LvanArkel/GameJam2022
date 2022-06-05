extends Node2D


var enemy_material
var enemy_visible = true

func _ready():
	randomize()

func update_enemy(enemy):
	enemy.get_node("Sprite").material = enemy_material
	enemy.get_node("Sprite").visible = enemy_visible
	enemy.get_node("Particles").visible = not enemy_visible

func _on_ChaosController_update_enemy_texture(e_material, e_visible):
	enemy_material = e_material
	enemy_visible = e_visible
	for child in get_children():
		update_enemy(child)


func _on_WaveController_spawn_enemy(enemy):
	update_enemy(enemy)	
	add_child(enemy)
