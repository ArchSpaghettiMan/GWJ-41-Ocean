extends AudioStreamPlayer


func _ready():
	play()


func _on_Crash_sound_finished():
	queue_free()
