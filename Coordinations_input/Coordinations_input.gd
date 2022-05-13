extends Control


func _process(_delta):
	if Input.is_action_just_pressed("enter"):
		if ($X_input.text + $Y_input.text).is_valid_integer():
			var destination_x = clamp(int($X_input.text), 20, 1260)
			var destination_y = clamp(int($Y_input.text), 20,604)
			get_tree().call_group("Ship", "move_to_point", \
				Vector2(destination_x, destination_y))
		
		else:
			get_tree().call_group("Announcement_label", "set_text",\
				"Invalid ship destination!")
			$Error.play()
