extends Node2D

export var event_spawn_time = 5.0

export var storm_path : PackedScene

export var fishing_point_path : PackedScene


func _ready():
	spawn_storm()
	spawn_fishing_point()


func _process(_delta):
	set_fish_amount_label()
	set_time_limit_label()


func spawn_storm():
	var storm_instance = storm_path.instance()
	
	$Events/Storm.add_child(storm_instance)
	
	storm_instance.connect("finished_storm_event", self, "spawn_storm")


func spawn_fishing_point():
	var fishing_point_instance = fishing_point_path.instance()
	
	$Events/Fishing_points.add_child(fishing_point_instance)
	
	fishing_point_instance.connect("finished_fishing_point_event", \
		self, "spawn_fishing_point")


func set_fish_amount_label():
	$Control/Top_screen/Fish_amount/Fish_amount_label.text = \
		str(FishManager.fish_amount)


func set_time_limit_label():
	var minutes = 0
	var seconds = 0
	var current_seconds = int(TimeLimit.time_left)
	
	minutes = floor(current_seconds / 60)
	seconds = current_seconds - minutes * 60
	
	$Control/Top_screen/Time_limit/Time_limit_label.text = \
		str(minutes) + ":" + str(seconds)
