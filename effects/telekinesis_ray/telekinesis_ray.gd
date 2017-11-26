extends Area2D

var velocity = Vector2(0, 0)

func _ready():
	set_process(true)

func _process(delta):
	rotate(delta)
	translate(velocity)

func _on_telekinesis_ray_body_entered( body ):
	pass # replace with function body
