extends RigidBody2D


var speed = 300
var target = Vector2(0,0)
var direction = Vector2(1,0)
var stopping_distance = 10.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var despawn = $despawn
signal enemy_hit(enemy)
var despawn_timer_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = direction * speed
	animated_sprite.play("default")
	

func _physics_process(delta):
	scale = Vector2(Global.get_fireball_value("scale"),Global.get_fireball_value("scale"))
	# Calculate the direction to the target
	var direction = global_position.direction_to(target)
	
	# Check if the body is close enough to the target to stop
	if global_position.distance_to(target) > stopping_distance:
		# Move towards the target
		linear_velocity = direction * speed
	else:
		# Stop when close enough to the target
		linear_velocity = Vector2.ZERO
		if !despawn_timer_started:
			despawn.start()
			despawn_timer_started = true

func set_target(targ):
	target = targ

func _on_area_2d_body_entered(body):
	if(body.is_in_group("player")):
		add_collision_exception_with(body)
	if(body.is_in_group("enemy")):
		enemy_hit.emit(body)


func _on_despawn_timeout():
	queue_free()
