extends Node2D

export var radius = 90
export var lifetime = 35

signal finished_fishing_point_event


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
	emit_signal("finished_fishing_point_event")
	queue_free()


func _on_Area2D_area_entered(area):
	if !is_instance_valid(area.get_owner()):
		return
	if area.get_owner().is_in_group("Ship"):
		area.get_owner().fishing_bonus = true


func _on_Area2D_area_exited(area):
	if !is_instance_valid(area.get_owner()):
		return
	if area.get_owner().is_in_group("Ship"):
		area.get_owner().fishing_bonus = false
