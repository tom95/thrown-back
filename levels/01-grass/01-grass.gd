extends "res://levels/level.gd"

const NEXT_LEVEL = "res://levels/04-cave/04-cave.tscn"

signal cow_killed(num_total)
signal next_level(next_level)

var cows_killed = 0
var farmer_count = 0

func _ready():
	for cow in $cows.get_children():
		connect_character_signals(cow)
		cow.connect("cow_killed", self, "_on_cow_killed")

func _on_cow_killed():
	cows_killed = cows_killed + 1
	emit_signal("cow_killed", cows_killed)
	spawn_farmer()

func _on_farmer_killed():
	farmer_count -= 1
	if farmer_count < 1:
		$superjump/superjump_prop.activate()

func spawn_farmer():
	farmer_count += 1
	if farmer_count > 0:
		$superjump/superjump_prop.deactivate()
	var farmer = preload("res://characters/farmer/farmer.tscn").instance()
	farmer.position = get_node("farmer_spawn").global_position + Vector2(cows_killed * 50, 0)
	connect_character_signals(farmer)
	farmer.connect("farmer_killed", self, "_on_farmer_killed")
	add_child(farmer)

func _on_level_end_area_body_entered( body ):
	if body.is_in_group("players"):
		emit_signal("next_level", NEXT_LEVEL)
