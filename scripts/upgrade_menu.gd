extends Node2D

@onready var barracks = $barracks
@onready var castle = $"level_one_castle-sprite"
@onready var upgradeMenu = $CanvasLayer
@onready var barracks_info = $CanvasLayer/barracks_info

@onready var Fireball = $CanvasLayer/fireball_panel/fireball
@onready var lock = $CanvasLayer/lock
@onready var purchase_barracks_button = $CanvasLayer/purchase_barracks
@onready var purchase_fireball_button = $CanvasLayer/purchase_fireball
@onready var level_label = $CanvasLayer/barracks_info/level_panel/Label
@onready var health_label = $CanvasLayer/barracks_info/health_panel/Label
@onready var damage_label = $CanvasLayer/barracks_info/damage_panel2/Label
@onready var fireball_scale_label = $CanvasLayer/fireball_scale/Label
@onready var fireball_damage_label = $CanvasLayer/fireball_panel/damage_panel/Label
@onready var barracks_upgrade_price_label = $CanvasLayer/barracts_cost/Label2
@onready var fireball_scale_upgrade_price_label = $CanvasLayer/scale_cost/Label2
@onready var fireball_damage_upgrade_price_label = $CanvasLayer/scale_cost2/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	upgradeMenu.hide()
	barracks.hide()
	barracks_info.hide()
	update_levels()
	update_fireball()
	Global.fireball_upgraded.connect(update_fireball)


func _on_upgrades_pressed():
	upgradeMenu.show()


func _on_close_pressed():
	upgradeMenu.hide()

func update_levels():
	var price = Global.get_barracks_value("cost")
	barracks_upgrade_price_label.text = str(price)
	if Global.barracks_unlocked:
		barracks.show()
		lock.hide()
		purchase_barracks_button.text = "UPGRADE BARRACKS"
		barracks_info.show()
		update_reinforcement_values()
	else:
		purchase_barracks_button.text = "UNLOCK BARRACKS"

func update_reinforcement_values():
	level_label.text = str(Global.get_barracks_value("level"))
	health_label.text = str(Global.get_barracks_value("health"))
	damage_label.text = str(Global.get_barracks_value("damage"))
	

func _on_start_next_wave_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_purchase_barracks_pressed():
	var price = Global.get_barracks_value("cost")
	if(Global.money >= price):
		if Global.barracks_unlocked:
			Global.upgrade_barracks()
		else:
			Global.barracks_unlocked = true
		Global.subtract_coins(price)
		update_levels()

func update_fireball():
	fireball_scale_upgrade_price_label.text = str(Global.get_fireball_value("scale_cost"))
	fireball_damage_upgrade_price_label.text = str(Global.get_fireball_value("damage_cost"))
	fireball_damage_label.text = str(Global.get_fireball_value("damage"))
	fireball_scale_label.text = "Scale " + str(Global.get_fireball_value("scale"))
	Fireball.scale = Vector2(Global.get_fireball_value("scale"),Global.get_fireball_value("scale"))
	

func _on_purchase_fireball_pressed():
	var scale_price = Global.get_fireball_value("scale_cost")
	if Global.money >= scale_price:
		Global.upgrade_fireball_scale()
		Global.subtract_coins(scale_price)


func _on_purchase_fireball_damage_pressed():
	var damage_price = Global.get_fireball_value("damage_cost")
	if Global.money >= damage_price:
		Global.upgrade_fireball_damage()
		Global.subtract_coins(damage_price)
