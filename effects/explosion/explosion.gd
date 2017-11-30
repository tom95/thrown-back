extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func big_explosion():
	scale *= 10
	$fire.speed_scale = $fire.get_speed_scale() / 4
	$smoke.speed_scale = $smoke.get_speed_scale() / 4
	$white_streaks.speed_scale = $white_streaks.get_speed_scale() / 4
	$Timer.wait_time = 4