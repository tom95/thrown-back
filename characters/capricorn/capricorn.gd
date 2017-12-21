extends "res://characters/npc_bouncer.gd"

const COOLDOWN = 1200
var ram_cooldown = 0
var attacking = false
var attackee = null
var direction = 1


func _ready():
	pass

func _process(delta):
	ram_cooldown = max(0, ram_cooldown - 1000 * delta)
	if attacking and ram_cooldown <= 0:
		ram()
	
	turn_to_direction_of_velocity()

func ram():
	ram_cooldown = COOLDOWN
	linear_velocity =  (attackee.global_position - global_position) * 2

func _on_attack_area_body_entered( body ):
	if body.is_in_group("players"):
		attacking = true
		attackee = body

func _on_attack_area_body_exited( body ):
	if body.is_in_group("players"):
		attacking = false
		attackee = null

func get_resource_path():
	return "res://characters/capricorn/capricorn.tscn"

func _on_capricorn_body_entered( body ):
	if body.is_in_group("players"):
		body.rammed(linear_velocity)
