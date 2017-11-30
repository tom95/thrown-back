extends "res://levels/level.gd"

signal boss_fight_started(max_health)
signal boss_health_updated(health)
signal boss_killed

var boss_fight_started = false

func _ready():
	$characters/beholder.connect("update_boss_health", self, "_on_boss_health_updated")
	$characters/beholder.connect("boss_killed", self, "_on_boss_killed")

func needs_light():
	return true

func get_beholder_area():
	var area = $lair/area/collision.shape
	return Rect2(
		$lair/area/collision.global_position - area.extents,
		area.extents * 2)

func _on_lair_area_body_entered( body ):
	if body.is_in_group("players") and not boss_fight_started:
		boss_fight_started = true
		$characters/beholder.start_engaging(body, get_beholder_area())
		emit_signal("boss_fight_started", $characters/beholder.MAX_HEALTH)
		
func _on_boss_health_updated(health):
	emit_signal("boss_health_updated", health)
	
func _on_boss_killed():
	emit_signal("boss_killed")