extends "res://characters/npc_bouncer.gd"

func _ready():
	pass
	
func despawn():
	.despawn()
	if health <= 0:
		var player = get_node("../../wizard")
		player.increment_cow_counter()