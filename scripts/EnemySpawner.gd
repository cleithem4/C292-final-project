extends Node2D

@onready var spawn_enemy_timer = $spawn_enemy
@onready var wave_complete_timer = $wave_complete
@onready var Enemy := load("res://enemy/enemy.tscn")
@onready var Wizard := load("res://wizard/cursed_wizard.tscn")

var numOfUnitsSpawned = 2
var current_enemies = []
var unit_type = {
	1 : "res://enemy/enemy.tscn",
	2 : "res://wizard/cursed_wizard.tscn"
}
# Called when the node enters the scene tree for the first time.
func _ready():
	start_wave()



func spawn_enemy(type):
	Enemy = load(unit_type[type])
	var enemy = Enemy.instantiate()
	add_child(enemy)
	current_enemies.append(enemy)
	enemy.enemy_killed.connect(_on_enemy_killed)
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

func _on_enemy_killed(enemy):
	current_enemies.erase(enemy)
	if current_enemies.size() < 1:
		wave_complete()

func start_wave():
	numOfUnitsSpawned = round(Global.wave * 2) + 4
	spawn_enemy_timer.start()
	
	
func wave_complete():
	wave_complete_timer.start()
	

func _on_spawn_enemy_timeout():
	if numOfUnitsSpawned > 0:
		var random_type = randi_range(1, unit_type.size())
		spawn_enemy(random_type)
		numOfUnitsSpawned -= 1
	else:
		spawn_enemy_timer.stop()


func _on_wave_complete_timeout():
	Global.wave_complete()
	get_tree().change_scene_to_file("res://UI/upgrade_menu.tscn")
