extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var heart_texture
var unequiped_weapon_color = Color(0.4, 0.4, 0.4)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cols/Row1/Lives.get_color("font_color")
	heart_texture = load("res://assets/sprites/UI/heart.png")


func update_player_info(money, lives, active_weapon, ammos):
	$Cols/Row1/Money.text = "$"+str(money)
	update_lives(lives)
	if active_weapon == 0:
		$Cols/Row2/PistolAmmoImage.modulate = Color(1,1,1)
	else:
		$Cols/Row2/PistolAmmoImage.modulate = unequiped_weapon_color
	$Cols/Row2/PistolAmmoLabel.text = "= " + str(ammos[0])
	if active_weapon == 1:
		$Cols/Row2/ShotgunAmmoImage.modulate = Color(1,1,1)
	else:
		$Cols/Row2/ShotgunAmmoImage.modulate = unequiped_weapon_color
	$Cols/Row2/ShotgunAmmoLabel.text = "= " + str(ammos[1])
	if active_weapon == 2:
		$Cols/Row2/RifleAmmoImage.modulate = Color(1,1,1)
	else:
		$Cols/Row2/RifleAmmoImage.modulate = unequiped_weapon_color
	$Cols/Row2/RifleAmmoLabel.text = "= " + str(ammos[2])

func update_lives(lives):
	lives = max(lives, 0)
	var lives_on_hud = $Cols/Row1/Lives.get_child_count()
	if lives > lives_on_hud:
		for i in range(lives-lives_on_hud):
			var heart_symbol = TextureRect.new()
			heart_symbol.texture = heart_texture
			$Cols/Row1/Lives.add_child(heart_symbol)
	elif lives < lives_on_hud:
		for i in range(lives_on_hud - lives):
			$Cols/Row1/Lives.get_children()[i].queue_free()
