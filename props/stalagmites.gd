extends Area2D

const DAMAGE = 300

func _ready():
	pass

func _on_stalagmites_body_entered( body ):
	if body.is_in_group("characters"):
		body.take_damage(DAMAGE, $stalagmites.texture)
