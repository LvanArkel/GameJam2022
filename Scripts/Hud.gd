extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Cols/Row1/Lives.get_color("font_color")


func update_player_info(money, lives, active_weapon, ammos):
	$Cols/Row1/Money.text = "$"+str(money)
	if active_weapon == 0:
		$Cols/Row2/PistolAmmoImage.modulate = Color(1,1,1)
	else:
		$Cols/Row2/PistolAmmoImage.modulate = Color(0.6, 0.6, 0.6)
	$Cols/Row2/PistolAmmoLabel.text = "= " + str(ammos[0])
	if active_weapon == 1:
		$Cols/Row2/ShotgunAmmoImage.modulate = Color(1,1,1)
	else:
		$Cols/Row2/ShotgunAmmoImage.modulate = Color(0.6, 0.6, 0.6)
	$Cols/Row2/ShotgunAmmoLabel.text = "= " + str(ammos[1])
	if active_weapon == 2:
		$Cols/Row2/RifleAmmoImage.modulate = Color(1,1,1)
	else:
		$Cols/Row2/RifleAmmoImage.modulate = Color(0.6, 0.6, 0.6)
	$Cols/Row2/RifleAmmoLabel.text = "= " + str(ammos[2])
