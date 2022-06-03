extends Area2D

export (int) var bullet_speed

var bullet_range = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * bullet_speed * delta


func _on_Lifetime_timeout():
	queue_free()
