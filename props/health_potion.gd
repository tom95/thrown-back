extends Area2D

const HEAL_POWER = 800

func _ready():
	pass

func _on_health_potion_body_entered( body ):
	if body.is_in_group("players"):
		body.heal(HEAL_POWER)
		queue_free()
