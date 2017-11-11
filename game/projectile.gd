extends RigidBody2D

func _ready():
	set_process(true)

func _process(delta):
	pass

func _on_Timer_timeout():
	queue_free()
