extends Node2D

func _ready():
	set_process(true)

func _process(delta):
	$light.energy = rand_range(1.2, 1.4)