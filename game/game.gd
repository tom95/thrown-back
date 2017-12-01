extends Node2D

var killed_enemies = {}

func _ready():
	$wizard.connect("killed", self, "game_over")
	set_process(true)
	setup_level()

func _process(delta):
	if Input.is_action_just_pressed("debug_change_level_1"):
		show_level("res://levels/01-grass/01-grass.tscn")
	elif Input.is_action_just_pressed("debug_change_level_3"):
		show_level("res://levels/03-ice/03-ice.tscn")
	elif Input.is_action_just_pressed("debug_change_level_4"):
		show_level("res://levels/04-cave/04-cave.tscn")
	elif Input.is_action_just_pressed("debug_godmode_on"):
		$wizard.is_in_godmode = true
	elif Input.is_action_just_pressed("debug_godmode_off"):
		$wizard.is_in_godmode = false
	elif Input.is_action_just_pressed("teleport_to_boss"):
		$wizard.position = $level.get_boss_fight_position()

func show_level(path):
	remove_child($level)
	var new_level = load(path).instance()
	new_level.set_name("level")
	add_child(new_level)
	move_child($level, 0)
	setup_level()

func setup_level():
	$level.connect("cow_killed", $hud, "_on_cow_killed")
	$level.connect("boss_fight_started", $hud, "_on_boss_fight_started")
	$level.connect("boss_health_updated", $hud, "_on_boss_health_updated")
	$level.connect("boss_killed", self, "you_won")
	$level.connect("enemy_killed", self, "_on_enemy_killed")
	$level.connect("next_level", self, "show_level")
	$wizard/light.enabled = $level.needs_light()
	$wizard.position = $level.get_spawn_position()
	$wizard.velocity = Vector2(0, 0)

func stop_level():
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.queue_free()
	return root

func game_over(killed_by_texture):
	var root = stop_level()
	
	var game_over = preload("res://levels/game_over/game_over.tscn").instance()
	game_over.set_killed_by(killed_by_texture)
	root.add_child(game_over)

func you_won():
	killed_enemies["res://characters/beholder/beholder_endscreen.tscn"] = 1
	
	yield(get_tree().create_timer(4), "timeout")
	
	var root = stop_level()
	var you_won = preload("res://levels/you_won/you_won.tscn").instance()
	root.add_child(you_won)
	add_enemies(you_won)

func add_enemies(scene):
	for path in killed_enemies:
		var enemy = load(path)
		for i in range(killed_enemies[path]):
			var instance = enemy.instance()
			var size = scene.get_viewport().size
			instance.linear_velocity = Vector2(500, 0).rotated(rand_range(0, 2 * PI))
			instance.position = Vector2(rand_range(0, size.x), rand_range(0, size.y))
			instance.friction = 0
			scene.add_child(instance)
			instance.mode = RigidBody2D.MODE_RIGID

func _on_enemy_killed(path):
	if not path in killed_enemies:
		killed_enemies[path] = 1
	else:
		killed_enemies[path] += 1
		
func show_instructions(show):
	$hud/explanation.visible = show