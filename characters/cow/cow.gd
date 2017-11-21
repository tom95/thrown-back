extends "res://characters/npc_bouncer.gd"

func _ready():
	pass
	
func hit_by_firebolt():
	.hit_by_firebolt()
	if health <= 0:
		var player = get_node("../../wizard")
		player.cow_counter = player.cow_counter + 1
		print(player.cow_counter)