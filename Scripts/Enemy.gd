extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var speed = 20

var root
var screen_size
var vel = Vector2(speed, speed)

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().root.get_child(0)
	screen_size = get_viewport_rect().size
	
	add_force(Vector2(), vel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var pos = position
	var changed = false
	
	if pos.x >= screen_size.x:
		vel = Vector2(-vel.x, vel.y)
		changed = true
	elif pos.y >= screen_size.y:
		vel = Vector2(vel.x, -vel.y)
		changed = true
		
	if changed:
		add_force(Vector2(), vel)
