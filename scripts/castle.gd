extends StaticBody2D


@onready var health_label = $health_bar/BoxContainer/Label
@onready var health_progress_bar = $health_bar
@onready var fire_particles = $fire_particles
@onready var Fireball = load("res://castle/fireball.tscn")
@onready var fireball_spawn = $fireball_spawn
@onready var reload = $reload

var health = 100
var MAX_HEALTH = 100
var ATTACK_DAMAGE = 20.0
var able_to_attack = true

func _ready():
	updateHealthDisplay()

func _process(_delta):
	if Input.is_action_just_pressed("left_click"):
		var pos = get_global_mouse_position()
		if able_to_attack:
			shoot_fireball(pos)
			able_to_attack = false
			fire_particles.hide()
			reload.start()


func damage(attack: Attack):
	health -= attack.attack_damage
	updateHealthDisplay()
	if health <= 0:
		queue_free()

func updateHealthDisplay():
	health_label.text = str(round(health))
	var new_progress_bar_value = (health/MAX_HEALTH) * 100
	animate_progress_bar(new_progress_bar_value,0.4)

func animate_progress_bar(target_value: float, duration: float):
	var tween = get_tree().create_tween()
	# Stop any previous animations on the tween
	# Start a new tween to animate the progress bar value
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(health_progress_bar, "value", target_value,duration)

func shoot_fireball(targ):
	var fireball = Fireball.instantiate()
	add_child(fireball)
	fireball.enemy_hit.connect(_on_enemy_hit)
	fireball.global_position = fireball_spawn.global_position
	fireball.set_target(targ)
	
	

func _on_enemy_hit(enemy):
	if(enemy != null):
		var attack = Attack.new()
		attack.attack_damage = ATTACK_DAMAGE
		attack.attack_position = self.global_position
		enemy.damage(attack)


func _on_reload_timeout():
	fire_particles.show()
	able_to_attack = true
