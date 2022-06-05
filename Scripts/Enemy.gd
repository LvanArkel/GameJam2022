extends KinematicBody2D

export (int) var speed = 100
export (int) var health = 3
export (int) var attack_length = 100
export (int) var damage = 1

var texture_scale

onready var nav: Navigation2D = get_node(@"/root/Main/NavMesh")
onready var player = get_node(@"../../Player")

var line
var path = []
var line_path = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var c = Color.from_hsv(randf(), 1, 1)
	$Sprite.modulate = c
	$Particles.color = c
	texture_scale = $Sprite.scale.x
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#line.points = line_path
	
	_update_navigation_path(position, player.position)
	
	var walk_distance = speed * delta
	
	move_along_path(walk_distance)
	
func attack():
	var dist = player.position.distance_to(position)
	
	if dist < attack_length:
		player.damage(damage)
	
func move_along_path(distance):
	var last_point = position
	while path.size():
		attack()
		
		var distance_between_points = last_point.distance_to(path[0])

		# The position to move to falls between two points.
		if distance <= distance_between_points:
			var old_pos = position
			position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			var delta_pos = position - old_pos
			var delta_pos_sign = sign(delta_pos.x)
			$Sprite.scale.x = (delta_pos_sign if delta_pos_sign != 0 else 1)*texture_scale
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# The character reached the end of the path.
	position = last_point
	set_process(false)
	
func _update_navigation_path(start_position, end_position):
	path = nav.get_simple_path(start_position, end_position, true)
	line_path = path
	
	# The first point is always the start_position.
	path.remove(0)
	
	set_process(true)

func take_damage(amount):
	health -= amount
	
	if health == 0:
		die()


func die():
	$"/root/Main"._on_Enemy_enemy_death(position)
	queue_free()
