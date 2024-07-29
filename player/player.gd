extends CharacterBody2D


@export_category("Movement")
@export var speed:float = 3
@export_category("Sword")
@export var sword_damage: int = 2
@export_category("Ritual")
@export var ritual_damage: int = 1
@export var ritual_interval: float = 30
@export var ritual_scene: PackedScene
@export_category("Life")
@export var health: int = 100
@export var max_health: int = 100
@export var death_body: PackedScene

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite = $Sprite
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_progress_bar: ProgressBar = $HealthProgressBar

var direction: Vector2 = Vector2.ZERO
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 0.0

func _ready() -> void:
	health_progress_bar.max_value = max_health
	
func _process(delta):

	input_read()
	play_run_idle_animation()
	flip_sprite()
	update_attack_cooldown(delta)
	update_hitbox_detection(delta)
	update_ritual(delta)
	health_progress_bar.value = health
	GameManager.player_position = position


func _physics_process(delta):
	var target_velocity = direction * speed * 100.0
	if is_attacking:
		target_velocity *= 0.2
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()


func attack() -> void:
	if is_attacking:
		return
	animation_player.play("attack_side_1")
	attack_cooldown = 0.4
	is_attacking = true


func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var direction_to_enemy = (body.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			if direction_to_enemy.dot(attack_direction) > 0.2:
				body.damage(sword_damage)


func input_read() -> void:
	if Input.is_action_just_pressed("attack"):
		attack()
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if  abs(direction.x) < 0.15:
		direction.x = 0
	if  abs(direction.y) < 0.15:
		direction.y = 0
	was_running = is_running
	is_running = not direction.is_zero_approx()


func flip_sprite() -> void:
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0: 
		sprite.flip_h = true


func play_run_idle_animation() -> void:
	if was_running != is_running and !is_attacking:
		if is_running:
			animation_player.play("run")
		else:
			animation_player.play("idle")


func update_attack_cooldown(delta: float):
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")


func update_ritual(delta:float) -> void:
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	ritual_cooldown = ritual_interval
	
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)


func damage(amount: int)->void:
	if health <= 0: return
	health -= amount
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	if health <=0:
		die()


func heal(amount: int) -> int:
	health+= amount
	if health >= max_health:
		health = max_health
	return health


func  die()->void:
	if death_body:
		var death_object = death_body.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	GameManager.stop_spawners()
	queue_free()


func update_hitbox_detection(delta):
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return

	hitbox_cooldown = 0.5
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			damage(1)

