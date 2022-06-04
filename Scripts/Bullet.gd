extends Area2D

export (int) var bullet_speed

var bullet_range = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * bullet_speed * delta


func _on_Lifetime_timeout():
	queue_free()


func _on_Bullet_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	# add logic for damaging enemies
	
	if body.is_in_group("Player"):
		# no friendly fire in a single player game lmao
		return
	
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
