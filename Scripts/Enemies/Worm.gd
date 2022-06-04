extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(-60,0)

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var collision = $HeadKinematic.move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
