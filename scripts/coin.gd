extends Node2D

var value = 0
var direction = Vector2(0,0)
var speed = 200.0
var damping = 0.98
var move_towards_label = false
var got_direction = false
@onready var area_pos = get_node("/root/main/Castle")


func _ready():
	$Timer.start()


func _process(delta):
	if(move_towards_label):
		speed = 300.0
		direction = -(global_position - area_pos.global_position).normalized()
		var move_amount = direction * speed * delta
		position += move_amount
	else:
		speed = speed * damping
		var move_amount = direction * speed * delta
		position += move_amount

func set_direction(new_direction: Vector2):
	direction = new_direction


func _on_timer_timeout():
	move_towards_label = true
