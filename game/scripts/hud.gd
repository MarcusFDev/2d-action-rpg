extends Control

var last_health := 3  # Track the previous health

@onready var hearts := [$HealthBar/Heart1, $HealthBar/Heart2, $HealthBar/Heart3]

func _ready() -> void:
	GameManager.connect("health_changed", self._on_health_changed)

func _on_health_changed(current_health):
	for i in range(last_health - 1, current_health - 1, -1):
		if i >= 0 and i < hearts.size():
			hearts[i].play("lose_health")
	last_health = current_health
