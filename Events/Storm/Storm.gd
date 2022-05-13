extends Node2D

export var radius = 70
export var lifetime = 15

var ships_in_storm = {}

export var damage = 1
export var damage_delay = 2.5

export var damage_timer_path : PackedScene

signal finished_storm_event


func _ready():
	$Spawn_sound.play()
	
	randomize()
	
	spawn_random()

	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	
	$Area2D/CollisionShape2D.shape.radius = radius


func spawn_random():
	var spawn_point_x = int(rand_range(20 + radius, 1260 - radius))
	while spawn_point_x in range(545, 735):
		spawn_point_x = int(rand_range(20 + radius, 1260 - radius))
	
	var spawn_point_y = int(rand_range(20 + radius, 604 - radius))
	while spawn_point_y in range(217, 407):
		spawn_point_y = int(rand_range(20 + radius, 604 - radius))
	
	global_position = Vector2(spawn_point_x, spawn_point_y)



func _on_Lifetime_timeout():
	emit_signal("finished_storm_event")
	queue_free()


func _on_Area2D_area_entered(area):
	if area.get_owner().is_in_group("Ship"):
		
		var damage_timer = damage_timer_path.instance()
		damage_timer.wait_time = damage_delay
		damage_timer.target = area.get_owner()
		
		ships_in_storm[area.get_owner().name] = [area.get_owner(), damage_timer]
		add_child(damage_timer)


func _on_Area2D_area_exited(area):
	if !is_instance_valid(area.get_owner()):
		return
	elif ships_in_storm.has(area.get_owner().name):
		ships_in_storm[area.get_owner().name][1].queue_free()
		ships_in_storm.erase(area.get_owner().name)


func damage_ship(ship):
	if ships_in_storm.has(ship.name):
		ship.damaged(damage)


func ship_crashed(ship_name):
	if ships_in_storm.has(ship_name):
		ships_in_storm[ship_name][1].queue_free()
		ships_in_storm.erase(ship_name)
