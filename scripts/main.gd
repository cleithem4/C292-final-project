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
	enemy.global_position = get_random_screen_pos()

func get_random_screen_pos() -> Vector2:
	var viewport_rect = get_viewport().get_visible_rect()
	
	# Get the center of the screen
	var screen_center = viewport_rect.size / 2
	
	# Generate a random direction (angle in radians)
	var random_angle = randf_range(0, 2 * PI)
	
	# Set the minimum distance to 400 units
	var min_distance = 400
	
	# Generate a random distance from the center, starting at 400 units and up to the edge of the screen
	var max_distance = viewport_rect.size.length() / 2  # Half the diagonal of the screen
	var random_distance = randf_range(min_distance, max_distance)
	
	# Calculate the random position using the angle and distance
	var random_offset = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	var random_position = screen_center + random_offset
	
	# Return the random position
	return random_position
	
