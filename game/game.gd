extends Node2D

onready var fuel_meter = get_node("hud/fuel_meter")
onready var player = get_node("player")

func _ready():
	#player_size = get_node("player").get_texture().get_size()
	set_process(true)

func _process(delta):
	fuel_meter.value = player.jetpack_fuel
	fuel_meter.max_value = player.max_jetpack_fuel