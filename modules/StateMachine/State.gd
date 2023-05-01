class_name State
extends Node


var machine: StateMachine = null

# warning-ignore:unused_signal
signal transition(state_name)


func handle_input(_event: InputEvent): pass
func process(_delta: float): pass
func physics_process(_delta: float): pass
func enter(): pass
func exit(): pass

func transition(state_name):
	emit_signal("transition", state_name)

func active() -> bool:
	return machine.state.name == name
