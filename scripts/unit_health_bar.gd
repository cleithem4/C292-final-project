extends Node2D

@onready var health_progress_bar = $health_bar
@onready var health_label = $health_bar/BoxContainer/Label



func update():
	health_label.text = str(get_parent().health)
	var new_progress_bar_value = (get_parent().health/get_parent().MAX_HEALTH) * 100
	animate_progress_bar(new_progress_bar_value,0.4)

func animate_progress_bar(target_value: float, duration: float):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(health_progress_bar, "value", target_value,duration)
