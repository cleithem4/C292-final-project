extends CharacterBody2D

const SPEED = 1.0
@onready var animationPlayer = $AnimationPlayer
@export var repulsionArea : Area2D
@export var attackRadius : Area2D
@onready var attack_rate_timer = $attack_rate
@onready var attack_buffer = $attack_buffer
@onready var level_one_sprite = $knight_sprite/level_one
@onready var level_five_sprite = $knight_sprite/level_five
@onready var nav_agent = $NavigationAgent2D
@onready var level_ten_sprite = $knight_sprite/level_ten
@onready var level_fifteen_sprite = $knight_sprite/level_fifteen

var repulsionForce_array = []
var enemy_units = []
var enemy = null
var screen_size = Vector2(1280,640)
var dead = false
var attack_radius = 20.0
var atk_dmg = 10.0
var able_to_attack = true
var health = 20.0
var attacking = false
var spread_radius = 10.0


func _ready():
	Global.barracks_upgraded.connect(_on_barracks_upgraded)
	_on_barracks_upgraded()

func _physics_process(delta):
	
	if dead:
		return
	velocity = Vector2.ZERO

	if repulsionForce_array.size() != 0:
		var repulsion_force = Vector2.ZERO
		for UNIT in repulsionForce_array:
			repulsion_force += (global_position - UNIT.global_position).normalized() * 0.5
		global_position += repulsion_force


	if enemy_units.size() != 0:
		select_enemy()
	else:
		enemy = null


	if enemy != null:
		# Get enemy's collision shape size (e.g., assume circle radius for simplicity)
		var enemy_radius = 0.0
		if enemy is CollisionObject2D and enemy.get_child_count() > 0:
			var collision_shape = enemy.get_child(0)
			if collision_shape is CollisionShape2D:
				var shape = collision_shape.shape
				if shape is CircleShape2D:
					enemy_radius = shape.radius
				elif shape is RectangleShape2D:
					enemy_radius = max(shape.extents.x, shape.extents.y)

		# Calculate target position aligned with enemy's y-axis
		var total_radius = attack_radius + enemy_radius
		var target_position = Vector2(
			enemy.global_position.x + sign(global_position.x - enemy.global_position.x) * total_radius,  # Adjusted for attack distance
			enemy.global_position.y  # Align on the y-axis
		)

		# Set the target position for the NavigationAgent
		var target_offset_y = randf_range(-spread_radius, spread_radius)  # Random offset in the y-axis
		target_position.y += target_offset_y  # Apply the offset to the y-axis
		nav_agent.set_target_position(target_position)

		# Check if the AI has reached the target position
		if global_position.distance_to(target_position) > 10: # Allow slight tolerance
			var next_position = nav_agent.get_next_path_position()
			velocity += (next_position - global_position).normalized() * SPEED
		else:
			# Stop moving and attack if within range
			velocity = Vector2.ZERO
			if able_to_attack:
				attack(enemy)
				return
			
	if velocity.length() > 0 and !attacking:
		animationPlayer.play("walk")
	elif !attacking:
		animationPlayer.play("idle")
	global_position.x = clamp(global_position.x,0,screen_size.x)
	global_position.y = clamp(global_position.y,0,screen_size.y)
	global_position += velocity
	move_and_slide()


func attack(enemy):
	attacking = true
	if global_position.x < enemy.global_position.x:
		animationPlayer.play("attack")
	else:
		animationPlayer.play("attack_left")
	if enemy.has_method("damage"):
		attack_buffer.start()
		able_to_attack = false
		attack_rate_timer.start()

func damage(attack: Attack):
	health -= attack.attack_damage
	if health <= 0:
		queue_free()

func select_enemy():
	var closest_distance = 99999999
	enemy = null
	
	for e in enemy_units:
		var distance = global_position.distance_to(e.global_position)
		if distance < closest_distance:
			enemy = e
			closest_distance = distance


func _on_attack_radius_body_entered(body):
	if body.is_in_group("enemy"):
		enemy_units.append(body)
func _on_attack_radius_body_exited(body):
	if body.is_in_group("enemy"):
		enemy_units.erase(body)


func _on_attack_rate_timeout():
	attacking = false
	able_to_attack = true


func _on_attack_buffer_timeout():
	var attack = Attack.new()
	attack.attack_damage = atk_dmg
	if enemy:
		enemy.damage(attack)

func _on_barracks_upgraded():
	health = Global.get_barracks_value("health")
	atk_dmg = Global.get_barracks_value("damage")
	
	var level = Global.get_barracks_value("level")
	if level > 14:
		level_five_sprite.hide()
		level_one_sprite.hide()
		level_ten_sprite.hide()
		level_fifteen_sprite.show()
	elif level > 9:
		level_five_sprite.hide()
		level_one_sprite.hide()
		level_ten_sprite.show()
		level_fifteen_sprite.hide()
	elif level > 4:
		level_five_sprite.show()
		level_one_sprite.hide()
		level_ten_sprite.hide()
		level_fifteen_sprite.hide()
	else:
		level_five_sprite.hide()
		level_one_sprite.show()
		level_ten_sprite.hide()
		level_fifteen_sprite.hide()
		

func _on_repulsion_area_body_entered(body):
	if body != self and body.is_in_group("unit"):
		repulsionForce_array.append(body)


func _on_repulsion_area_body_exited(body):
	if body != self and body.is_in_group("unit"):
		repulsionForce_array.erase(body)
