extends RigidBody2D


var speed = 300
var target = Vector2(0,0)
var direction = Vector2(1,0)
var stopping_distance = 10.0
var dmg = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = direction * speed
	

func _physics_process(delta):
	
	# Calculate the direction to the target
	var direction = global_position.direction_to(target)
	
	# Check if the body is close enough to the target to stop
	if global_position.distance_to(target) > stopping_distance:
		# Move towards the target
		linear_velocity = direction * speed
	else:
		# Stop when close enough to the target
		linear_velocity = Vector2.ZERO


func set_target(targ):
	target = targ

func _on_area_2d_body_entered(body):
	if(body.is_in_group("player_units")):
		if body.has_method("damage"):
			var attack = Attack.new()
			attack.attack_damage = dmg
			attack.attack_position = self.global_position
			if is_instance_valid(body):
				body.damage(attack)
			self.queue_free()
	if(body.is_in_group("castle")):
		if body.has_method("damage"):
			var attack = Attack.new()
			attack.attack_damage = dmg
			attack.attack_position = self.global_position
			if is_instance_valid(body):
				body.damage(attack)
			self.queue_free()

