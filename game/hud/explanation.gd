extends Node2D

var all_keys = {
	"jump": false,
	"move_left": false,
	"move_right": false,
	"airblast": false,
	"fire": false
}

func _ready():
	set_process_input(true)

func _input(event):
	var all_true = true
	for key in all_keys:
		if Input.is_action_pressed(key):
			all_keys[key] = true
		if not all_keys[key]:
			all_true = false

	if all_true:
		set_process_input(false)
		$tween.interpolate_property($image,
			"self_modulate",
			Color(1, 1, 1, 1),
			Color(1, 1, 1, 0),
			2,
			Tween.TRANS_SINE,
			Tween.EASE_IN)
		$tween.start()
		yield($tween, "tween_completed")
		queue_free()
