class_name BTAction
extends BTNode

var intent_value: String

func _init(_intent: String) -> void:
	intent_value = _intent

func tick(_actor: Node, blackboard: Dictionary) -> int:
	var fsm : Variant = blackboard.get("fsm", null)
	if fsm and fsm.current_state.name != intent_value + "State":
		blackboard["intent"] = intent_value
		return BTNode.BTResult.RUNNING
	return BTNode.BTResult.SUCCESS
