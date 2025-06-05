extends ScrollContainer

@export var snap_interval := 220.0
@export var snap_speed := 10.0

var target_scroll := 0.0
var snapping := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
