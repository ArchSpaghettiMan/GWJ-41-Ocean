extends KinematicBody2D

var State
enum State_list {MOVING, FISHING, CLAIMING}

var chosen := false

var fishing_destination := Vector2()
var speed := 20

export var max_hp = 4
var hp = max_hp

export var fishing_speed = 1.0
export var catch_amount = 1
var fishing_bonus = false
var fish_amount = 0
export var max_fish_amount = 50

var in_dock = false

export var crash_sound_path : PackedScene


func _ready():
	State = State_list.MOVING
	fishing_destination = global_position
	
	$Fishing_timer.wait_time = fishing_speed
	
	update_health_label()


func _physics_process(delta):
	state_manager(delta)


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("left_click"):
			change_chosen_state()


func move_to_point(destination):
	if !chosen:
		return
	
	change_chosen_state()
	fishing_destination = destination
	State = State_list.MOVING


func state_manager(delta):
	if global_position.distance_to(fishing_destination) <= 0.2:
		if in_dock:
			State = State_list.CLAIMING
		elif !in_dock:
			State = State_list.FISHING
	else:
		State = State_list.MOVING
	
	match State:
		State_list.MOVING:
			moving(delta)
			$Fishing_timer.stop()
		State_list.FISHING:
			fishing()
		State_list.CLAIMING:
			$Fishing_timer.stop()


func fishing():
	if $Fishing_timer.time_left == 0:
		$Fishing_timer.start()


func moving(delta):
	var direction = (fishing_destination - global_position).normalized()
	var velocity = direction * speed
	var collision = move_and_collide(velocity*delta)
	
	if direction.x < 0:
		$Sprite.flip_h = false
		$CollisionShape2D.scale.x = 1
		$Area2D.scale.x = 1
	elif direction.x > 0:
		$Sprite.flip_h = true
		$CollisionShape2D.scale.x = -1
		$Area2D.scale.x = -1
	
	collision_check(collision)
	
	draw_path()


func change_chosen_state():
	chosen = !chosen
	if chosen: modulate = Color(0,0,1)
	else: modulate = Color(1,1,1)


func collision_check(collision):
	if collision:
		if collision.collider.is_in_group("Ship"):
			collision.collider.crash()
		crash()


func crash():
	var crash_sound = crash_sound_path.instance()
	get_parent().add_child(crash_sound)
	
	get_tree().call_group("Storm","ship_crashed",name)
	get_tree().call_group("Dock","ship_crashed",self)
	
	get_tree().call_group("Announcement_label", "set_text",\
			"Ship crashed!")
	
	queue_free()


func draw_path():
	$Path_line.set_point_position(1, fishing_destination - global_position)
	pass


func damaged(amount):
	hp -= amount
	
	update_health_label()
	
	if hp <= 0:
		crash()


func _on_Fishing_timer_timeout():
	if !fishing_bonus:	fish_amount += catch_amount
	else:	fish_amount += catch_amount * 2
	
	fish_amount = clamp(fish_amount, 0, max_fish_amount)
	
	$Fishing_timer.start()
	
	update_fish_amount()


func update_fish_amount():
	$Fish_amount/Fish_amount_label.text = str(fish_amount)


func update_health_label():
	$Health_label.text = "HP: " + str(hp)
