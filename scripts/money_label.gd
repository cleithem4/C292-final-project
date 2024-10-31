extends CanvasLayer

@onready var money_label = $ColorRect/money
@onready var reinforcement_progress_bar = $ColorRect2/ProgressBar
@onready var reinforcement_rect = $ColorRect2
@onready var wave_label = $wave
var is_animating = false

signal spawn_knight

func _ready():
	Global.wave_updated.connect(_on_wave_updated)
	var parent = get_parent()
	if parent.name == "UpgradeMenu" or !Global.barracks_unlocked:
		reinforcement_rect.hide()
	else:
		reinforcement_rect.show()
	update_reinforcement_bar()
	_on_wave_updated()

func _process(_delta):
	money_label.text = str(Global.money)
	if reinforcement_progress_bar.value == 0:
		update_reinforcement_bar()

func update_reinforcement_bar():
	animate_progress_bar(100, 1.5)

func _on_spawn_reinforcements_pressed():
	if reinforcement_progress_bar.value >= 100:
		spawn_knight.emit()
		animate_progress_bar(0, 0.6)
		update_reinforcement_bar()

func animate_progress_bar(target_value: float, duration: float):
	if is_animating:
		return 

	is_animating = true
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(reinforcement_progress_bar, "value", target_value, duration)
	tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
	is_animating = false

func _on_wave_updated():
	wave_label.text = "Wave " + str(Global.wave)
