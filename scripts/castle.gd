extends StaticBody2D


@onready var health_label = $health_bar/BoxContainer/Label
@onready var health_progress_bar = $health_bar

var health = 100
var MAX_HEALTH = 100


func _ready():
	updateHealthDisplay()

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
	# Stop any previous animations on the tween

	# Start a new tween to animate the progress bar value
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(health_progress_bar, "value", target_value,duration)
