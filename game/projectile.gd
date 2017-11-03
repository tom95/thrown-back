extends RigidBody2D

func _ready():
	set_process(true)

func _process(delta):
	get_node("sprite").rotate(delta * 10)