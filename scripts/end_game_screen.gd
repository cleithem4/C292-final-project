extends CanvasLayer

@onready var coins_label = $Panel/coins


func _ready():
	self.hide()
	Global.wave_lost.connect(_on_wave_lost)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_wave_lost():
	self.show()
	animate_coin_label(Global.current_wave_coins,1.5)
	

	

func _on_return_home_pressed():
	get_tree().change_scene_to_file("res://UI/upgrade_menu.tscn")

# Function to animate the coin label smoothly
func animate_coin_label(target_value: float, duration: float):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	# Tween the displayed_coins variable from its current value to target_value
	tween.tween_property(self,"displayed_coins", target_value, duration)
# This setter updates the label text every time displayed_coins changes
var displayed_coins: int:
	set(value):
		displayed_coins = value
		coins_label.text = str(displayed_coins)
