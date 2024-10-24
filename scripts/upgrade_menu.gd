extends Node2D

@onready var barracks = $CanvasLayer/barracks
@onready var castle = $"level_one_castle-sprite"
@onready var upgradeMenu = $CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	upgradeMenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_upgrades_pressed():
	upgradeMenu.show()


func _on_close_pressed():
	upgradeMenu.hide()


func _on_start_next_wave_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
