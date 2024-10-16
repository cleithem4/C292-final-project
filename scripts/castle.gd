extends StaticBody2D

var health = 100

func _ready():
	pass # Replace with function body.

func _process(_delta):
	pass


func damage(attack: Attack):
	health -= attack.attack_damage
	if health <= 0:
		queue_free()
