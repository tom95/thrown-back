extends "res://levels/level.gd"

func _ready():
	pass

func needs_light():
	return true

func _on_beholder_influence_area_body_entered( body ):
	if body.is_in_group("players"):
		$characters/beholder.start_engaging(body, get_beholder_area())

func get_beholder_area():
	var area = $beholder_influence_area/collision.shape
	return Rect2(
		$beholder_influence_area/collision.global_position - area.extents,
		area.extents * 2)