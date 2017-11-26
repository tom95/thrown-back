extends "res://levels/level.gd"

func _ready():
	pass

func needs_light():
	return true

func get_beholder_area():
	var area = $lair/area/collision.shape
	return Rect2(
		$lair/area/collision.global_position - area.extents,
		area.extents * 2)

func _on_lair_area_body_entered( body ):
	if body.is_in_group("players"):
		$characters/beholder.start_engaging(body, get_beholder_area())
