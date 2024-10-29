extends StaticBody2D

@onready var health_label = $health_bar/BoxContainer/Label
@onready var health_progress_bar = $health_bar


var health = 50
var MAX_HEALTH = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
