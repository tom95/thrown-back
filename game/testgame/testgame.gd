extends Node2D

func _ready():
	set_process(true)
	$level.connect("spawn", self, "_on_spawn_requested")
	$level.connect("cow_killed", $hud, "_on_cow_killed")
	$wizard.connect("killed", $hud, "game_over")

func _process(delta):
	pass

func _on_spawn_requested(object):
	add_child(object)
