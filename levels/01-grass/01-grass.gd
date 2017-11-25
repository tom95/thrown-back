extends "res://levels/level.gd"

signal cow_killed(num_total)

var cows_killed = 0

func _ready():
	for cow in $cows.get_children():
		connect_character_signals(cow)
		cow.connect("killed", self, "_on_cow_killed")

func _on_cow_killed():
	cows_killed = cows_killed + 1
	emit_signal("cow_killed", cows_killed)
