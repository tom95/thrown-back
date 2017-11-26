extends Node2D

func _ready():
	$wizard.connect("killed", self, "game_over")
	set_process(true)
	setup_level()

func _process(delta):
	if Input.is_action_just_pressed("debug_change_level_1"):
		show_level("res://levels/01-grass/01-grass.tscn")
	elif Input.is_action_just_pressed("debug_change_level_4"):
		show_level("res://levels/04-cave/04-cave.tscn")

func show_level(path):
	remove_child($level)
	var new_level = load(path).instance()
	new_level.set_name("level")
	add_child(new_level)
	move_child($level, 0)
	setup_level()

func setup_level():
	$level.connect("cow_killed", $hud, "_on_cow_killed")
	$wizard/light.enabled = $level.needs_light()
	$wizard.position = $level.get_spawn_position()

func game_over(killed_by_texture):
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.queue_free()
	
	var game_over = preload("res://levels/game-over/game-over.tscn").instance()
	game_over.set_killed_by(killed_by_texture)
	root.add_child(game_over)