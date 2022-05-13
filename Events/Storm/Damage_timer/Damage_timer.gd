extends Timer

var target


func _on_Damage_timer_timeout():
	get_parent().damage_ship(target)
	start()
