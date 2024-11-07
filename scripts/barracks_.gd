extends StaticBody2D

@onready var health_label = $health_bar/BoxContainer/Label
@onready var health_progress_bar = $health_bar
@onready var unit_spawn = $unit_spawn_location
@onready var Knight = load("res://knight/knight.tscn")


var health = 50
var MAX_HEALTH = 50

var knights_list = []


# Called when the node enters the scene tree for the first time.
func _ready():
	updateHealthDisplay()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func damage(attack: Attack):
	health -= attack.attack_damage
	updateHealthDisplay()
	if health <= 0:
		queue_free()

func updateHealthDisplay():
	health_label.text = str(round(health))
	var new_progress_bar_value = (health/MAX_HEALTH) * 100
	animate_progress_bar(new_progress_bar_value,0.4)

func animate_progress_bar(target_value: float, duration: float):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(health_progress_bar, "value", target_value,duration)

func spawn_knight():
	var knight = Knight.instantiate()
	get_tree().root.add_child(knight)
	knight.global_position = unit_spawn.global_position
	knight.scale = Vector2(1.5,1.5)
	knights_list.append(knight)


func _on_spawn_knight_pressed():
	spawn_knight()


func _on_money_label_spawn_knight():
	spawn_knight()
