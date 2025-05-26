extends Control

var last_health := 3  # Track the previous health

@onready var hearts := [$HealthBar/Heart1, $HealthBar/Heart2, $HealthBar/Heart3]

func _ready() -> void:
	return
