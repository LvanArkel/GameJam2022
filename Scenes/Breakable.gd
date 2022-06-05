extends Node2D

var health = 4
export (int) var chaos_type = 1

onready var chaos_controller = get_node("/root/Main/ChaosController")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage():
	if health > 0:
		health -= 1
	
		chaos_controller.trigger_chaos(chaos_type)

func repair():
	
	print("chaos_controller repair")


func _on_CPU_Breakable_area_entered(area):
	if area.is_in_group("Bullet"):
		take_damage()
		area.queue_free()


func _on_CPU_Breakable_body_entered(body):
	
	if body.is_in_group("Player"):
		print("Player entered")
		var purchase_sprite = body.get_node("PurchaseSprite")
		body.can_buy = true
		body.chaos_repair_type = chaos_type
		body.buy_type = "chaos"
		purchase_sprite.visible = true


func _on_CPU_Breakable_body_exited(body):
	if body.is_in_group("Player"):
		print("Player exited")
		var purchase_sprite = body.get_node("PurchaseSprite")
		body.can_buy = false
		purchase_sprite.visible = false
