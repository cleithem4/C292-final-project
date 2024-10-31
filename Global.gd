extends Node

var money = 1000
var wave = 1

var barracks = {
	"level" : 1,
	"health" : 20.0,
	"damage" : 10.0,
}

var fireball = {
	"scale" : 0.5
}

var barracks_unlocked = false

signal barracks_upgraded
signal fireball_upgraded
signal wave_updated


func wave_complete():
	wave += 1
	for player_unit in get_tree().get_nodes_in_group("player_units"):
		player_unit.queue_free()
	wave_updated.emit()

func get_barracks_value(key):
	return barracks[key]

func set_barracks_value(key, new_value):
	barracks[key] = new_value

func get_fireball_value(key):
	return fireball[key]

func set_fireball_value(key, new_value):
	fireball[key] = new_value

func upgrade_barracks():
	set_barracks_value("level",get_barracks_value("level")+1)
	set_barracks_value("health",get_barracks_value("health") +10)
	set_barracks_value("damage",get_barracks_value("damage") + 5)
	barracks_upgraded.emit()

func upgrade_fireball():
	set_fireball_value("scale",get_fireball_value("scale") + 0.25)
	fireball_upgraded.emit()

	
