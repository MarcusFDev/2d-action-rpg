class_name PlayerTakeDamage
extends State

@export var hurt_duration : float = 0.5
@export var knockback_velocity : Vector2 = Vector2(-150, -150)
@export var invincibility_time : float = 1.0
var knockback_source_position: Vector2
var knockback_source_velocity: Vector2
var invincibility_timer : float = 0.0
var invincible : bool = false
var timer : float = 0.0

func enter() -> void:
	timer = hurt_duration
	invincibility_timer = invincibility_time
	invincible = true
	animations.play("take_damage")
	
	var direction: float = sign(knockback_source_velocity.x)
	if direction == 0:
		direction = sign(parent.global_position.x - knockback_source_position.x)
	parent.velocity = Vector2(knockback_velocity.x * direction, knockback_velocity.y)
	

func process_physics(delta: float) -> State:
	timer -= delta
	if invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			invincible = false
	
	# Apply gravity to vertical velocity
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if timer <= 0:
		return parent.state_machine.starting_state
	return null
