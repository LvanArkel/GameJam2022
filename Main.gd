extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Control/Labels/WeaponCooldown.text = str($Player/WeaponSlot/Weapon/Cooldown.time_left)


func _on_Player_spawn_bullet(bullets):
	for bullet in bullets:
		$Bullets.add_child(bullet)
