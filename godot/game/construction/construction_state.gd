class_name ConstructionState
extends RefCounted

var _level = null

func create(level):
	_level = level

func create_simulation_state() -> SimulationState:
	var sim_state = SimulationState.new()
	sim_state.create(20, 16, _level, [], [])
	return sim_state
