class_name SlimeAttackState
extends State

@onready var timer: Timer = $attack_timer
@export var slime_idle: SlimeIdleState
var finished : bool = false

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	super.enter()
	finished = false
	animations.play("slime_attack")
	
	if not timer.is_connected("timeout", _on_attack_timer_timeout):
		timer.connect("timeout", _on_attack_timer_timeout)
	timer.start()

func _on_attack_timer_timeout() -> void:
	finished = true

func process_frame(_delta: float) -> State:
	if finished:
		return slime_idle
	return null
