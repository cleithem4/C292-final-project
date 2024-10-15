extends Node2D

@onready var Enemy := load("res://enemy/enemy.tscn")

@onready var button = $Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var enemy = Enemy.instantiate()
	add_child(enemy)
	enemy.global_position = Vector2(100,100)
	
