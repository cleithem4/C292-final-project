extends Node

var money = 20
var current_wave_coins = 0
var wave = 6

var barracks = {
	"level" : 1,
	"health" : 20.0,
	"damage" : 10.0,
	"cost": 50.0
}

var fireball = {
	"scale" : 0.75,
	"damage" : 20.0,
	"scale_cost" : 100.0,
	"damage_cost" : 100.0
}



var barracks_unlocked = false

signal barracks_upgraded
signal fireball_upgraded
signal wave_updated
signal wave_lost


func add_coins(coins):
	money += coins
	current_wave_coins += coins
	
func subtract_coins(coins):
	money -= coins

func wave_complete():
	wave += 1
	for player_unit in get_tree().get_nodes_in_group("player_units"):
		player_unit.queue_free()
	wave_updated.emit()
	current_wave_coins = 0

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
	set_barracks_value("cost",get_barracks_value("cost") + 20)
	barracks_upgraded.emit()

func upgrade_fireball_scale():
	set_fireball_value("scale",get_fireball_value("scale") + 0.25)
	set_fireball_value("scale_cost",get_fireball_value("scale_cost") + 150)
	fireball_upgraded.emit()
func upgrade_fireball_damage():
	set_fireball_value("damage",get_fireball_value("damage") + 20)
	set_fireball_value("damage_cost",get_fireball_value("damage_cost") + 100)
	fireball_upgraded.emit()
	
