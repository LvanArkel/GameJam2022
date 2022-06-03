extends Area2D

export (int) var bullet_speed

var bullet_range = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * bullet_speed * delta


func _on_Lifetime_timeout():
	queue_free()
