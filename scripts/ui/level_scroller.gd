extends ScrollContainer

@export var snap_interval : float = 220.0
@export var snap_speed : float = 10.0

var target_scroll : float = 0.0
var snapping : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
