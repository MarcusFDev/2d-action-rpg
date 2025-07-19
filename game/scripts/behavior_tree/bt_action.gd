extends BTNode

@export var target_state_node: State

func tick(actor: Node, blackboard_node: Node) -> BTResult:
	if not target_state_node:
		return BTResult.FAILURE

	var fsm = blackboard_node.get_value("fsm")

	if not fsm:
		return BTResult.FAILURE
	
	if fsm.current_state != target_state_node:
		print("BTAction ticked. FSM current:", fsm.current_state.name, " Target:", target_state_node.name)
		print("FSM current ID:", fsm.current_state.get_instance_id(), " Target ID:", target_state_node.get_instance_id())
		fsm.change_state(target_state_node)
		return BTResult.RUNNING

	return BTResult.SUCCESS
