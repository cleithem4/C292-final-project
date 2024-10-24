extends Node2D

@export var coin : PackedScene
var coins_spawned = 0
var remainder = 0
var COIN_VALUE = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Function to set the number of coins to spawn
func set_coin_amount(coins):
	coins_spawned = coins / 10 + 1
	while coins_spawned / 30 > 1:
		COIN_VALUE *= 2
		coins_spawned /= 2
	remainder = int(coins) % 10
	spawn_coins()

# Function to spawn coins in random directions
func spawn_coins():
	for i in range(coins_spawned):
		var random_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		var spawn_position = random_direction * 5  # Adjust radius as needed
		
		var new_coin = coin.instantiate()
		new_coin.position = position + spawn_position  # Spawn around the current node
		
		# Optionally, set the direction of the coin
		new_coin.set_direction(random_direction)
		if i >= coins_spawned-1:
			new_coin.value = remainder
		else:
			new_coin.value = 5
		
		
		get_tree().current_scene.add_child(new_coin)
