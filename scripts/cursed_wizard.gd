extends CharacterBody2D

const SPEED = 1.0
@onready var animationPlayer = $AnimationPlayer
@export var repulsionArea : Area2D
@export var attackRadius : Area2D
@onready var attack_rate_timer = $attack_rate
@onready var attack_buffer = $attack_buffer
@onready var coin_death_effect = load("res://coin_death_effect.tscn")
@onready var nav_agent = $NavigationAgent2D
@onready var Dark_Energy_Ball = load("res://wizard/dark_energy_ball.tscn")
@onready var wizard_sprite = $wizard_sprite
@export var health_display : Node2D

var repulsionForce_array = []
var buildings = []
var enemy_units = []
var enemy = null
var screen_size = Vector2(1280,640)
var dead = false
var attack_radius = 50.0
var atk_dmg = 10.0
var able_to_attack = true
var health = 20.0
var MAX_HEALTH = 20.0
var attacking = false
var spread_radius = 20.0

signal enemy_killed(enemy)

func _ready():
	if Global.wave >= 10:
		atk_dmg = 30.0
		health = 50.0
		wizard_sprite.modulate = Color("520c49")
	elif Global.wave >= 5:
		wizard_sprite.modulate = Color("0fa981")
		health = 40.0
		atk_dmg = 20.0
	else:
		wizard_sprite.modulate = Color("ffffff")
		health = 20.0
		atk_dmg = 10.0
	MAX_HEALTH = health
	health_display.update()
	nav_agent.set_target_position(Vector2.ZERO)

func _physics_process(delta):
	if dead:
		return
	velocity = Vector2.ZERO

	if repulsionForce_array.size() != 0:
		var repulsion_force = Vector2.ZERO
		for UNIT in repulsionForce_array:
			repulsion_force += (global_position - UNIT.global_position).normalized() * 0.5
		global_position += repulsion_force


	if enemy_units.size() != 0 or buildings.size() != 0:
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
		if global_position.distance_to(target_position) > 20: # Allow slight tolerance
			var next_position = nav_agent.get_next_path_position()
			velocity += (next_position - global_position).normalized() * SPEED
		else:
			# Stop moving and attack if within range
			velocity = Vector2.ZERO
			if able_to_attack:
				attack(enemy)
				return
	if enemy!= null:
		if global_position.x < enemy.global_position.x:
			wizard_sprite.scale.x = 1
		else:
			wizard_sprite.scale.x = -1
	if velocity.length() > 0 and !attacking:
		animationPlayer.play("idle")
	elif !attacking:
		animationPlayer.play("idle")
	global_position.x = clamp(global_position.x,0,screen_size.x)
	global_position.y = clamp(global_position.y,0,screen_size.y)
	global_position += velocity
	move_and_slide()


func attack(enemy):
	attacking = true
	if global_position.x < enemy.global_position.x:
		wizard_sprite.scale.x = 1
		var right_spawn_pos = $attack_right
		spawn_dark_energy_ball(enemy.global_position,right_spawn_pos.global_position)
	else:
		wizard_sprite.scale.x = -1
		var left_spawn_pos = $attack_left
		spawn_dark_energy_ball(enemy.global_position,left_spawn_pos.global_position)
	if enemy.has_method("damage"):
		#attack_buffer.start()
		able_to_attack = false
		attack_rate_timer.start()
		
func spawn_dark_energy_ball(target,spawn_pos):
	var dark_energy_ball = Dark_Energy_Ball.instantiate()
	add_child(dark_energy_ball)
	dark_energy_ball.set_target(target)
	dark_energy_ball.global_position = spawn_pos

func damage(attack: Attack):
	health -= attack.attack_damage
	health_display.update()
	if health <= 0:
		enemy_killed.emit(self)
		var new_coin_death_effect = coin_death_effect.instantiate()
		new_coin_death_effect.position = global_position
		get_tree().current_scene.add_child(new_coin_death_effect)
		new_coin_death_effect.set_coin_amount(10)
		queue_free()

func select_enemy():
	var closest_distance = 99999999
	enemy = null
	
	for e in enemy_units:
		var distance = global_position.distance_to(e.global_position)
		if distance < closest_distance:
			enemy = e
			closest_distance = distance
	if enemy_units.size() == 0:
		for e in buildings:
			var distance = global_position.distance_to(e.global_position)
			if distance < closest_distance:
				enemy = e
				closest_distance = distance


func _on_attack_radius_body_entered(body):
	if body.is_in_group("castle"):
		buildings.append(body)
	if body.is_in_group("player_units"):
		enemy_units.append(body)
func _on_attack_radius_body_exited(body):
	if body.is_in_group("castle"):
		buildings.erase(body)
	if body.is_in_group("player_units"):
		enemy_units.erase(body)

func _on_replusion_force_body_entered(body):
	if body != self and body.is_in_group("unit"):
		repulsionForce_array.append(body)


func _on_replusion_force_body_exited(body):
	if body != self and body.is_in_group("unit"):
		repulsionForce_array.erase(body)


func _on_attack_rate_timeout():
	able_to_attack = true
	attacking = false


func _on_attack_buffer_timeout():
	var attack = Attack.new()
	attack.attack_damage = atk_dmg
	if enemy:
		enemy.damage(attack)
