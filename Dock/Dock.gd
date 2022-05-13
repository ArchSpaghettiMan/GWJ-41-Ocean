extends StaticBody2D

export var radius = 100

export var claim_amount = 10
export var claim_time = 1.5

var ships_in_dock = []

export var ship_path : PackedScene

var placement_availability = true
export var ship_cost = 15


func _ready():
	$Area2D/CollisionShape2D.shape.radius = radius
	$Claim_timer.wait_time = claim_time


func _draw():
	draw_arc(Vector2(), radius, 0, 180, 1000, Color.green)


func _on_Area2D_area_entered(area):
	if !is_instance_valid(area.get_owner()):
		return
	
	elif area.get_owner().is_in_group("Ship"):
		ships_in_dock.append(area.get_owner())
		area.get_owner().in_dock = true
		
		area.get_owner().hp = area.get_owner().max_hp
		get_tree().call_group("Ship", "update_health_label")


func _on_Area2D_area_exited(area):
	if !is_instance_valid(area.get_owner()):
		return
	
	elif area.get_owner().is_in_group("Ship"):
		ship_crashed(area.get_owner())
		area.get_owner().in_dock = false


func _process(_delta):
	if ships_in_dock.size() > 0 and $Claim_timer.time_left == 0:
		$Claim_timer.start()
	
	if Input.is_action_just_pressed("dock_add_test"):
		if FishManager.fish_amount < ship_cost:
			get_tree().call_group("Announcement_label", "set_text",\
				"Not enough money to buy ship")
			$Error.play()
		elif !placement_availability:
			get_tree().call_group("Announcement_label", "set_text",\
				"No space available for new ship to dock")
			$Error.play()
		else:
			add_ship()


func _on_Claim_timer_timeout():
	if ships_in_dock.size() != 0:
		for i in ships_in_dock:
			if i.fish_amount >= claim_amount:
				i.fish_amount -= claim_amount
				FishManager.fish_amount += claim_amount
			else:
				pass
	
	get_tree().call_group("Ship", "update_fish_amount")


func ship_crashed(ship):
	if ships_in_dock.has(ship):
		ships_in_dock.erase(ship)


func add_ship():
	
	var ship_instance = ship_path.instance()
	ship_instance.global_position = global_position + Vector2(0,35)
	
	get_tree().call_group("ship_manager", "add_child", \
		ship_instance)
	
	FishManager.fish_amount -= ship_cost


func _on_Down_zone_area_entered(area):
	if is_instance_valid(area.get_owner()):
		if area.get_owner().is_in_group("Ship"):
			placement_availability = false


func _on_Down_zone_area_exited(area):
	if is_instance_valid(area.get_owner()):
		if area.get_owner().is_in_group("Ship"):
			placement_availability = true
