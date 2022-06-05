extends Node2D

var health = 4
export (int) var chaos_type = 1

onready var chaos_controller = get_node("/root/Motherboard/ChaosController")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage():
	if health > 0:
		health -= 1
	
		chaos_controller.trigger_chaos(chaos_type)

func repair():
	health = 4
	print("chaos_controller repair")


func _on_Breakable_area_entered(area):
	if area.is_in_group("Bullet"):
		take_damage()
		area.queue_free()


func _on_Breakable_body_entered(body):
	
	if body.is_in_group("Player"):
		var purchase_sprite = body.get_node("PurchaseSprite")
		var repair_sprite = body.get_node("RepairSprite")
		body.can_buy = true
		body.chaos_repair_type = chaos_type
		body.buy_type = "chaos"
		purchase_sprite.visible = true
		repair_sprite.visible = true


func _on_Breakable_body_exited(body):
	if body.is_in_group("Player"):
		var purchase_sprite = body.get_node("PurchaseSprite")
		var repair_sprite = body.get_node("RepairSprite")
		body.can_buy = false
		purchase_sprite.visible = false
		repair_sprite.visible = false


func _on_Player_repair_chaos(chaos_type):
	repair()
