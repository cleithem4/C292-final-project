extends Node2D

@onready var map1 = $CanvasLayer/Map1
@onready var barracks = $Barracks_

@onready var map2 = load("res://maps/map_2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	map1.show()
	barracks.hide()
	barracks.collision_layer = 0
	barracks.collision_mask = 0
	if(Global.barracks_unlocked):
		map1.queue_free()
		var Map2 = map2.instantiate()
		$CanvasLayer.add_child(Map2)
		Map2.show()
		barracks.show()
		barracks.collision_mask = 1
		barracks.collision_layer = 1
	
	
