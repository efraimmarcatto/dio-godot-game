extends CharacterBody2D
@onready var animation: AnimationPlayer = $Animation
@onready var attack_area: Area2D = $AttackArea
@onready var sprite: Sprite2D = $Sprite
@onready var health_progress_bar: ProgressBar = $HealthProgressBar
@onready var hitbox: Area2D = $Hitbox

@export_category("Movement")
@export var speed: int = 2
@export_range(0,1) var lerp_factor: float = 0.4
@export_category("Health")
@export var max_health: int = 30
@export var death_body: PackedScene
@export_category("Attack")
@export var attack_damage: int = 1

var health: int 
var direction: Vector2 = Vector2.ZERO
var was_running: bool = false
var is_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.6
var hitbox_cooldown: float

func _ready() -> void:
	if GameManager.player_texture:
		sprite.texture = GameManager.player_texture
	health = max_health
	health_progress_bar.max_value = max_health


func _process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("attack"):
		attack()
	was_running = is_running
	is_running = not direction.is_zero_approx()
	attack_cooldown_timer(delta)
	update_hitbox_detection(delta)
	flip_player()
	update_animation()
	update_health_bar()
	GameManager.player_position = position


func _physics_process(delta: float) -> void:
	var target_velocity = direction * speed * 100 
	velocity = lerp(velocity, target_velocity, lerp_factor)
	move_and_slide()


func update_animation() -> void:
	if was_running != is_running:
		if is_running:
			animation.play("run")
		else:
			animation.play("idle")


func flip_player() -> void:
	if direction.x > 0:
		sprite.flip_h = false
		attack_area.scale.x = 1
	elif direction.x < 0: 
		sprite.flip_h = true
		attack_area.scale.x = -1


func attack()->void:
	if is_attacking:
		return
	
	animation.play("attack1")
	attack_cooldown = 0.6
	is_attacking = true


func attack_cooldown_timer(delta: float):
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation.play("idle")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.damage(attack_damage)


func update_health_bar():
	health_progress_bar.value = health


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


func die():
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
	var bodies = hitbox.get_overlapping_bodies()
	for body in bodies:
		var enemy_damage = body.get("attack_damage") 
		if !enemy_damage:
			enemy_damage = 1
		if body.is_in_group("enemies"):
			damage(enemy_damage)

