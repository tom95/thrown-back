extends Node2D

func _ready():
	set_process(true)
	$level.connect("spawn", self, "_on_spawn_requested")
	$level.connect("cow_killed", $hud, "_on_cow_killed")
	$wizard.connect("killed", self, "game_over")

func _process(delta):
	pass

func _on_spawn_requested(object):
	add_child(object)

func game_over(killed_by_texture):
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.queue_free()
	
	var game_over = preload("res://levels/game-over/game-over.tscn").instance()
	game_over.set_killed_by(killed_by_texture)
	root.add_child(game_over)