extends Timer

export var limit = 240

var started = false
var ended = false


func _ready():
	wait_time = limit
	get_tree().paused = true
	
	$CanvasLayer/Start_game.visible = true
	$CanvasLayer/End_game.visible = false
	$CanvasLayer/Credits.visible = false


func _process(_delta):
	if !started and Input.is_action_just_pressed("Add_ship"):
		started = true
		$CanvasLayer/Start_game.visible = false
		
		get_tree().paused = false
		start()
	
	elif ended and Input.is_action_just_pressed("Add_ship"):
		get_tree().reload_current_scene()
	


func _on_Time_limit_timeout():
	get_tree().call_group("Announcement_label", "set_text", \
		"Out of time!")
	get_tree().paused = true
	
	$CanvasLayer/End_game.text = "Congratulations! You got " + \
		str(FishManager.fish_amount) + \
			" fishes!\nPress A to play again." 
	$CanvasLayer/End_game.visible = true
	$CanvasLayer/Credits.visible = true
	
	ended = true
