extends CharacterBody2D

const SPEED = 1.0
@onready var animationPlayer = $AnimationPlayer
@export var repulsionArea : Area2D
@export var attackRadius : Area2D
@onready var attack_rate_timer = $attack_rate

var repulsionForce_array = []
var enemy_units = []
var enemy = null
var screen_size = Vector2(1280,640)
var dead = false
var attack_radius = 100.0
var atk_dmg = 10.0
var able_to_attack = true

func _ready():
	pass

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
		var direction = global_position.direction_to(enemy.global_position)
		velocity += SPEED * direction
		global_position += velocity * delta
		if global_position.distance_to(enemy.global_position) < attack_radius:
			velocity = Vector2.ZERO
			if able_to_attack:
				attack(enemy)
			return
	if velocity > Vector2.ZERO:
		animationPlayer.play("walk")
	else:
		animationPlayer.play("idle")
	global_position.x = clamp(global_position.x,0,screen_size.x)
	global_position.y = clamp(global_position.y,0,screen_size.y)
	global_position += velocity
	move_and_slide()


func move_towards_enemy():
	pass


func attack(enemy):
	animationPlayer.play("attack")
	if enemy.has_method("damage"):
		var attack = Attack.new()
		attack.attack_damage = atk_dmg
		enemy.damage(attack)
		able_to_attack = false
		attack_rate_timer.start()


func select_enemy():
	var closest_distance = 99999999
	enemy = null
	
	for e in enemy_units:
		var distance = global_position.distance_to(e.global_position)
		if distance < closest_distance:
			enemy = e
			closest_distance = distance



func _on_attack_radius_body_entered(body):
	if body.is_in_group("castle"):
		enemy_units.append(body)

func _on_attack_radius_body_exited(body):
	if body.is_in_group("castle"):
		enemy_units.erase(body)

func _on_replusion_force_body_entered(body):
	if body != self and body.is_in_group("unit"):
		repulsionForce_array.append(body)


func _on_replusion_force_body_exited(body):
	if body != self and body.is_in_group("unit"):
		repulsionForce_array.erase(body)


func _on_attack_rate_timeout():
	able_to_attack = true
